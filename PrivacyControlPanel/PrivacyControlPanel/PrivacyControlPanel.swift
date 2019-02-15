//
//  PrivacyPolicyControlPanel.swift
//  Privacy-Policy-Control-Panel
//
//  Created by Pavel Kroh on 12/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import Foundation

public typealias RequestIdCallback = () -> Void

public typealias PrivacyControlPanelSetting = Dictionary<PrivacyControlPanel.Consent, PrivacyControlPanel.ConsentState>

@objc public class PrivacyControlPanel : NSObject, PCPViewControllerDelegate {
    
    static let keyPrefix = "privacy-control-panel"
    
    @objc public enum ConsentState: Int {
        case unknown = -2
        case notProvided = -1
        case provided = 1
    }
    
    @objc public enum Consent: Int, Comparable {
        
        case privacy
        case analytics
        
        var key: String {
            switch self {
            case .privacy:
                return "\(PrivacyControlPanel.keyPrefix)-privacy-consent"
            case .analytics:
                return "\(PrivacyControlPanel.keyPrefix)-analytics-consent"
            }
        }
        
        // why this is stored as bool even if there are three possible values in the enum?
        // to have direct UserDefaults mapping to system settings bundle
        var state: ConsentState {
            set {
                switch newValue {
                case .unknown:
                    UserDefaults.standard.removeObject(forKey: self.key)
                case .provided:
                    UserDefaults.standard.set(true, forKey: self.key)
                case .notProvided:
                    UserDefaults.standard.set(false, forKey: self.key)
                }
                UserDefaults.standard.synchronize()
            }
            get {
                guard let value = UserDefaults.standard.object(forKey: self.key) as? Bool else {
                    return .unknown
                }
                return value ? .provided: .notProvided
            }
        }
        
        func label() -> String {
            return NSLocalizedString(self.key, comment: "")
        }
        
        func detailUrl() -> URL? {
            let urlKey = "\(self.key)-url"
            let consentUrlString = NSLocalizedString(urlKey, comment: "")
            guard consentUrlString != urlKey else {
                return nil
            }
            return URL(string: consentUrlString)
        }
        
        public static func < (lhs: PrivacyControlPanel.Consent, rhs: PrivacyControlPanel.Consent) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

    }
    
    @objc public static func consent(for consent: Consent) -> ConsentState {
        return consent.state
    }
    
    @objc public static func removeAllConsents() {
        UserDefaults.standard.set(false, forKey: Consent.privacy.key)
        UserDefaults.standard.set(false, forKey: Consent.analytics.key)
    }

    @objc public static func resetAllConsents() {
        UserDefaults.standard.removeObject(forKey: Consent.privacy.key)
        UserDefaults.standard.removeObject(forKey: Consent.analytics.key)
    }
    
    @objc public static var wasShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "\(keyPrefix)-shown")
        }
    }

    private static var _shared: PrivacyControlPanel = {
       return PrivacyControlPanel()
    }()
    
    // MARK: - Presenting Control Panel
    
    private var originalKeyWindow: UIWindow?
    private var keyWindow: UIWindow?
    private var callback: RequestIdCallback?

    @objc static func show(consents: Dictionary<Int,Int>, callback: @escaping RequestIdCallback) {
        var swiftConsents = Dictionary<Consent,ConsentState>()
        consents.forEach { (key: Int, value: Int) in
            if let newKey = Consent(rawValue: key), let newValue = ConsentState(rawValue: value) {
                swiftConsents[newKey] = newValue
            }
        }
        show(for: swiftConsents, callback: callback)
    }
    
    public static func show(for consents: PrivacyControlPanelSetting, callback: @escaping RequestIdCallback) {
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
            viewController.consents = consents
            DispatchQueue.main.async {
                UserDefaults.standard.set(true, forKey: "\(keyPrefix)-shown")
                keyWindow.makeKeyAndVisible()
                keyWindow.rootViewController?.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    private var _viewController: PCPViewController?
    
    private var viewController: PCPViewController? {
        get {
            if _viewController != nil {
                return _viewController
            }
            guard let _viewController = UIStoryboard(name: "PrivacyControlPanel", bundle: Bundle(for: type(of: self))).instantiateInitialViewController() as? PCPViewController else {
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
    
    func viewControllerRequestClose(_ viewController: PCPViewController) {
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
