//
//  ConsentSDK.swift
//  ConsentSDK
//
//  Created by Pavel Kroh on 12/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import Foundation

@objc public class ConsentSDK : NSObject, CSDKViewControllerDelegate {
    
    static let keyPrefix = "consent-sdk"

    private static var _shared: ConsentSDK = {
        return ConsentSDK()
    }()
    
    // MARK: - Presenting Control Panel
    
    public typealias RequestIdCallback = () -> Void
    public typealias ConsentsSettings = Array<(consent: ConsentSDK.Consent, state: ConsentSDK.ConsentState)>
    
    private var originalKeyWindow: UIWindow?
    private var keyWindow: UIWindow?
    private var callback: RequestIdCallback?
    
    private static let defaultConsentsSettings: ConsentsSettings = [(.privacy, .provided), (.analytics, .provided)]
    
    // MARK: - Show control panel
    @objc public static var wasShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "\(keyPrefix)-shown")
        }
    }

    @objc public static func show(callback: @escaping RequestIdCallback) {
        show(with: defaultConsentsSettings, callback: callback)
    }

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
    @objc public static func check(callback: @escaping RequestIdCallback) {
        check(with: defaultConsentsSettings, callback: callback)
    }

    public static func check(with consentsSettings: ConsentsSettings, callback: @escaping RequestIdCallback) {
        var consentsHaveBeenSet = true
        consentsSettings.forEach { (key: ConsentSDK.Consent, value: ConsentSDK.ConsentState) in
            consentsHaveBeenSet = consentsHaveBeenSet && consentState(for: key) != .unknown
        }
        guard consentsHaveBeenSet else {
            show(with: consentsSettings, callback: callback)
            return
        }
        callback()
    }

    // MARK: - View Controller Implementation
    private var _viewController: CSDKViewController?
    
    private var viewController: CSDKViewController? {
        get {
            if _viewController != nil {
                return _viewController
            }
            guard let _viewController = UIStoryboard(name: "CSDKControlPanel", bundle: Bundle(for: type(of: self))).instantiateInitialViewController() as? CSDKViewController else {
                return nil
            }
            _viewController.delegate = self
            _viewController.modalTransitionStyle = .coverVertical
            // this ensures, together with the viewController.supportedInterfaceOrientations = .portrait
            // that the controller is never in landscape
            _viewController.modalPresentationStyle = .formSheet
            if let currentRootViewController = originalKeyWindow?.rootViewController, currentRootViewController.traitCollection.containsTraits(in: UITraitCollection(userInterfaceIdiom: .phone)) {
                _viewController.modalPresentationStyle = .fullScreen
            }
            return _viewController
        }
        set {
            _viewController = newValue
        }
    }
    
    func viewControllerRequestClose(_ viewController: CSDKViewController) {
        DispatchQueue.main.async {
            viewController.dismiss(animated: true) {
                self.originalKeyWindow?.makeKeyAndVisible()
                self.originalKeyWindow = nil
                self.keyWindow = nil
                self.viewController = nil
                self.callback?()
                self.callback = nil
            }
        }
    }
    
}
