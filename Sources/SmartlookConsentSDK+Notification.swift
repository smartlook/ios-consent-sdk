//
//  SmartlookConsentSDK+Notification.swift
//  SmartlookConsentSDK
//
//  Created by Pavel Kroh on 05/03/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import Foundation

extension SmartlookConsentSDK {

    private static var touchedName = "com.smartlook.SmartlookConsentSDK.notification.consentsTouched"

    /**
     This notification is sent whenever user touches the consents,
     regardless there is an actual change in the consents or not.
     */
    public static let consentsTouchedNotification = Notification.Name(rawValue: touchedName)
}
