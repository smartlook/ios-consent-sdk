//
//  SmartlookConsentSDK.swift
//  SmartlookConsentSDK
//
//  Created by Pavel Kroh on 12/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import Foundation
import UIKit

@objc public class SmartlookConsentSDK: NSObject, SLCViewControllerDelegate {

    private static let shared = SmartlookConsentSDK()
    private static let defaultConsentsSettings: ConsentsSettings = [(.privacy, .provided), (.analytics, .provided)]

    static let keyPrefix = "smartlook-consent-sdk"
    static let bundleName = "SmartlookConsentSDK"

    // MARK: - Private

    private var originalKeyWindow: UIWindow?
    private var keyWindow: UIWindow?
    private var callback: RequestIdCallback?

    // MARK: - Presenting Control Panel

    public typealias RequestIdCallback = () -> Void

    /**
     An array used to configure what consents with which default state appear in the control panel.
     If user already changed set its own state to a particular consent, her choice is respected
     and the default state is not used.
     */
    public typealias ConsentsSettings = [(consent: SmartlookConsentSDK.Consent,
                                          defaultState: SmartlookConsentSDK.ConsentState)]

    // MARK: - Show control panel

    /**
     Indicates whether the control panel was already shown at least once.
     */
    @objc public static var wasShown: Bool {
        return UserDefaults.standard.bool(forKey: "\(keyPrefix)-shown")
    }

    /**
     This method always opens the Control Panel for user to review the current consents states
     and calls the callback once the user confirm her choice in with the button there.
     */
    @objc public static func show(callback: @escaping RequestIdCallback) {
        show(with: defaultConsentsSettings, callback: callback)
    }

    /**
     This method always opens the Control Panel for user to review the current consents states
     and calls the callback once the user confirm her choice in with the button there.
     */
    public static func show(with consentsSettings: ConsentsSettings, callback: @escaping RequestIdCallback) {
        guard shared.keyWindow == nil else {
            return
        }

        var keyWindow: UIWindow?
        for window in UIApplication.shared.windows where window.isKeyWindow {
            keyWindow = window
            break
        }

        if let keyWindow = keyWindow {
            shared.originalKeyWindow = keyWindow
            shared.keyWindow = UIWindow()
            shared.callback = callback

            if let viewController = shared.viewController {
                shared.keyWindow?.windowLevel += 1
                shared.keyWindow?.accessibilityViewIsModal = true
                shared.keyWindow?.rootViewController = UIViewController()
                shared.keyWindow?.backgroundColor = UIColor.clear
                viewController.consents = consentsSettings

                DispatchQueue.main.async {
                    UserDefaults.standard.set(true, forKey: "\(keyPrefix)-shown")
                    shared.keyWindow?.makeKeyAndVisible()
                    shared.keyWindow?.rootViewController?.present(viewController, animated: true, completion: nil)
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                show(with: consentsSettings, callback: callback)
            }
        }
    }

    // MARK: - Check and show control panel

    /**
     This method checks if the user reviewed the default (i.e., `privacy` and `analytics` policies).
     If not, it opens the Control Panel and calls the callback once the user confirm her choice
     in with the button there. If the consents were already reviewed by the user, callback is called immediately.
    */
    @objc public static func check(callback: @escaping RequestIdCallback) {
        check(with: defaultConsentsSettings, callback: callback)
    }

    /**
     This method checks if the user reviewed the privacy policies enumerated in `ConsentsSettings` array.
     If not, it opens the Control Panel and calls the callback once the user confirm her choice
     in with the button there. If the consents were already reviewed by the user, callback is called immediately.
     */
    public static func check(with consentsSettings: ConsentsSettings, callback: @escaping RequestIdCallback) {
        var consentsHaveBeenSet = true
        consentsSettings.forEach { (key: SmartlookConsentSDK.Consent, _: SmartlookConsentSDK.ConsentState) in
            consentsHaveBeenSet = consentsHaveBeenSet && consentState(for: key) != .unknown
        }
        guard consentsHaveBeenSet else {
            show(with: consentsSettings, callback: callback)
            return
        }

        NotificationCenter.default.post(name: SmartlookConsentSDK.consentsTouchedNotification, object: nil)
        callback()
    }

    // MARK: - Control panel instantiate

    private var controlPanel: ControlPanelViewController?

    private func instantiateControlPanel() -> ControlPanelViewController? {
        // Framework is used as Swift Package
        #if SWIFT_PACKAGE
        let storyboard = UIStoryboard(name: "ControlPanel", bundle: Bundle.module)
        return storyboard.instantiateInitialViewController() as? ControlPanelViewController
        #endif

        // Framework is imported via legacy methods
        let thisBundle = Bundle(for: type(of: self))
        if thisBundle.bundleIdentifier == "com.smartlook.SmartlookConsentSDK" {
            let storyboard = UIStoryboard(name: "ControlPanel", bundle: thisBundle)
            return storyboard.instantiateInitialViewController() as? ControlPanelViewController

        } else if
            let cocoapodResourcesBundleUrl = thisBundle.url(forResource: Self.bundleName, withExtension: "bundle"),
            let cocoapodResourcesBundle = Bundle(url: cocoapodResourcesBundleUrl)
        {
            let storyboard = UIStoryboard(name: "ControlPanel", bundle: cocoapodResourcesBundle)
            return storyboard.instantiateInitialViewController() as? ControlPanelViewController
        }

        return nil
    }

    // MARK: - View Controller Implementation

    var viewController: ControlPanelViewController? {
        get {
            if controlPanel != nil {
                return controlPanel
            }

            controlPanel = instantiateControlPanel()
            guard let viewController = controlPanel else {
                return nil
            }

            // For tablet modes presents control panel as form
            viewController.delegate = self
            viewController.modalTransitionStyle = .coverVertical
            // This ensures, together with the viewController.supportedInterfaceOrientations = .portrait
            // that the controller is never in landscape.
            viewController.modalPresentationStyle = .formSheet

            // On phone presents control panel as full screen
            let phoneTraitCollection = UITraitCollection(userInterfaceIdiom: .phone)
            if
                let currentRootViewController = originalKeyWindow?.rootViewController,
                currentRootViewController.traitCollection.containsTraits(in: phoneTraitCollection)
            {
                viewController.modalPresentationStyle = .fullScreen
            }

            if #available(iOS 13.0, *) {
                // disable 'swipe to dismiss'
                viewController.isModalInPresentation = true
            }

            return viewController
        }
        set {
            controlPanel = newValue
        }
    }

    func viewControllerRequestClose(_ viewController: ControlPanelViewController) {
        DispatchQueue.main.async {
            viewController.dismiss(animated: true) { [weak self] in
                self?.originalKeyWindow?.makeKeyAndVisible()
                self?.originalKeyWindow = nil
                self?.keyWindow = nil
                self?.viewController = nil

                NotificationCenter.default.post(name: SmartlookConsentSDK.consentsTouchedNotification, object: nil)

                self?.callback?()
                self?.callback = nil
            }
        }
    }
}
