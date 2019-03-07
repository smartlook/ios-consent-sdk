//
//  ConsentSDK.swift
//  ConsentSDK
//
//  Created by Pavel Kroh on 12/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import Foundation

@objc public class SmartlookConsentSDK : NSObject, SLCViewControllerDelegate {
    
    static let keyPrefix = "smartlook-consent-sdk"

    private static var _shared: SmartlookConsentSDK = {
        return SmartlookConsentSDK()
    }()
    
    // MARK: - Presenting Control Panel
    
    public typealias RequestIdCallback = () -> Void
    
    /**
     An array used to configure what consents with which default state appear in the control panel. If user already changed set its own state to a particular consent, her choise is respected and the default state is not used.
     */
    public typealias ConsentsSettings = Array<(consent: SmartlookConsentSDK.Consent, defaultState: SmartlookConsentSDK.ConsentState)>
    
    private var originalKeyWindow: UIWindow?
    private var keyWindow: UIWindow?
    private var callback: RequestIdCallback?
    
    private static let defaultConsentsSettings: ConsentsSettings = [(.privacy, .provided), (.analytics, .provided)]
    
    // MARK: - Show control panel
    /**
     Indicates whenther the control panel was already shown at least once.
     */
    @objc public static var wasShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "\(keyPrefix)-shown")
        }
    }

    /**
     This method always opens the Control Panel for user to review the current consents states and calls the callback once the user confirm her choice in with the button there.
     */
    @objc public static func show(callback: @escaping RequestIdCallback) {
        show(with: defaultConsentsSettings, callback: callback)
    }

    /**
     This method always opens the Control Panel for user to review the current consents states and calls the callback once the user confirm her choice in with the button there.
     */
    public static func show(with consentsSettings: ConsentsSettings, callback: @escaping RequestIdCallback) {
        guard _shared.keyWindow == nil else {
            return
        }
        _shared.originalKeyWindow = UIApplication.shared.keyWindow
        _shared.keyWindow = UIWindow()
        _shared.callback = callback
        if let keyWindow = _shared.keyWindow, let viewController = _shared.viewController {
            keyWindow.windowLevel += 1
            keyWindow.accessibilityViewIsModal = true
            keyWindow.rootViewController = UIViewController()
            keyWindow.backgroundColor = UIColor.clear
            viewController.consents = consentsSettings
            DispatchQueue.main.async {
                UserDefaults.standard.set(true, forKey: "\(keyPrefix)-shown")
                keyWindow.makeKeyAndVisible()
                keyWindow.rootViewController?.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Check and show control panel
    /**
     This method checks if the user reviewed the default (i.e., `privacy` and `analytics` policies). If not, it opens the Control Panel and calls the callback once the user confirm her choice in with the button there. If the consents were already reviewed by the user, callback is called immediatelly.
    */
    @objc public static func check(callback: @escaping RequestIdCallback) {
        check(with: defaultConsentsSettings, callback: callback)
    }

    /**
     This method checks if the user reviewed the privacy policies enumerated in `ConsentsSettings` array. If not, it opens the Control Panel and calls the callback once the user confirm her choice in with the button there. If the consents were already reviewed by the user, callback is called immediatelly.
     */
    public static func check(with consentsSettings: ConsentsSettings, callback: @escaping RequestIdCallback) {
        var consentsHaveBeenSet = true
        consentsSettings.forEach { (key: SmartlookConsentSDK.Consent, value: SmartlookConsentSDK.ConsentState) in
            consentsHaveBeenSet = consentsHaveBeenSet && consentState(for: key) != .unknown
        }
        guard consentsHaveBeenSet else {
            show(with: consentsSettings, callback: callback)
            return
        }
        NotificationCenter.default.post(name: SmartlookConsentSDK.consentsTouchedNotification, object: nil)
        callback()
    }

    // MARK: - View Controller Implementation
    private var _viewController: ViewController?
    
    private var viewController: ViewController? {
        get {
            if _viewController != nil {
                return _viewController
            }
            let thisBundle = Bundle(for: type(of: self))
            if thisBundle.bundleIdentifier == "com.smartlook.SmartlookConsentSDK" {
                _viewController = UIStoryboard(name: "ControlPanel", bundle: thisBundle).instantiateInitialViewController() as? ViewController
            } else if let cocoapodResourcesBundleUrl = thisBundle.url(forResource: "SmartlookConsentSDK", withExtension: "bundle"), let cocoapodResourcesBundle = Bundle(url: cocoapodResourcesBundleUrl) {
                _viewController = UIStoryboard(name: "ControlPanel", bundle: cocoapodResourcesBundle).instantiateInitialViewController() as? ViewController
            }
            guard let viewController = _viewController else {
                return nil
            }
            viewController.delegate = self
            viewController.modalTransitionStyle = .coverVertical
            // this ensures, together with the viewController.supportedInterfaceOrientations = .portrait
            // that the controller is never in landscape
            viewController.modalPresentationStyle = .formSheet
            if let currentRootViewController = originalKeyWindow?.rootViewController, currentRootViewController.traitCollection.containsTraits(in: UITraitCollection(userInterfaceIdiom: .phone)) {
                viewController.modalPresentationStyle = .fullScreen
            }
            return _viewController
        }
        set {
            _viewController = newValue
        }
    }
    
    func viewControllerRequestClose(_ viewController: ViewController) {
        DispatchQueue.main.async {
            viewController.dismiss(animated: true) {
                self.originalKeyWindow?.makeKeyAndVisible()
                self.originalKeyWindow = nil
                self.keyWindow = nil
                self.viewController = nil
                NotificationCenter.default.post(name: SmartlookConsentSDK.consentsTouchedNotification, object: nil)
                self.callback?()
                self.callback = nil
            }
        }
    }
    
}
