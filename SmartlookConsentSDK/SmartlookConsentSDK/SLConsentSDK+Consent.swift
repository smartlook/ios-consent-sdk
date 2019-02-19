//
//  SmartlookConsentSDK+Consent.swift
//  SmartlookConsentSDK
//
//  Created by Pavel Kroh on 18/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import Foundation

extension SmartlookConsentSDK {
    public typealias Consent = String
}

extension SmartlookConsentSDK.Consent {
    public static let privacy: SmartlookConsentSDK.Consent = "privacy"
    public static let analytics: SmartlookConsentSDK.Consent = "analytics"
}

extension SmartlookConsentSDK {

    /**
     Indicates whether user seen and provided consent to a policy.
     
     `.unknown` state indicates that the user did not reviewed the policy

     `.notProvided` state indicates that the user explicitely refused consent to the policy
     
     `.provided` state indicates that the user explicitely provided consent to the policy
     */
    @objc(SLCConsentState) public enum ConsentState: Int {
        case unknown = -2
        case notProvided = -1
        case provided = 1
    }

    static func key(for consent: Consent) -> String {
        return "\(SmartlookConsentSDK.keyPrefix)-\(consent)-consent"
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
    
    /**
     The current consent state.
     */
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
