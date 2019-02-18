//
//  ConsentSDK+Consent.swift
//  ConsentSDK
//
//  Created by Pavel Kroh on 18/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import Foundation

extension ConsentSDK {
    public typealias Consent = String
}

extension ConsentSDK.Consent {
    public static let privacy: ConsentSDK.Consent = "privacy"
    public static let analytics: ConsentSDK.Consent = "analytics"
}

extension ConsentSDK {
    
    @objc(CSDKConsentState) public enum ConsentState: Int {
        case unknown = -2
        case notProvided = -1
        case provided = 1
    }

    static func key(for consent: Consent) -> String {
        return "\(ConsentSDK.keyPrefix)-\(consent)-consent"
    }
    
    static func set(state: ConsentState, for consent: Consent) {
        switch state {
        case .unknown:
            UserDefaults.standard.removeObject(forKey: key(for: consent))
        case .provided:
            UserDefaults.standard.set(true, forKey: key(for: consent))
        case .notProvided:
            UserDefaults.standard.set(false, forKey: key(for: consent))
        }
        UserDefaults.standard.synchronize()
    }
    
    @objc public static func consentState(for consent: Consent) -> ConsentState {
        guard let value = UserDefaults.standard.object(forKey: key(for: consent)) as? Bool else {
            return .unknown
        }
        return value ? .provided: .notProvided
    }
    
    static func label(for consent: Consent) -> String {
        return NSLocalizedString(key(for: consent), comment: "")
    }
    
    static func detailUrl(for consent: Consent) -> URL? {
        let urlKey = "\(key(for: consent))-url"
        let consentUrlString = NSLocalizedString(urlKey, comment: "")
        guard consentUrlString != urlKey else {
            return nil
        }
        return URL(string: consentUrlString)
    }
}
