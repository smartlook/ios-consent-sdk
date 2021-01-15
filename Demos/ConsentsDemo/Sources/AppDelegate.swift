//
//  AppDelegate.swift
//  ConsentSDKDemo
//
//  Created by Pavel Kroh on 18/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit
import SmartlookConsentSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - Consent check

    /** This method is to be invoked any time the app starts to check if the consents are provided
     namely in:
     - `application:didFinishWithLaunchingOptions` for the fresh start
     - `application:WillEnterForeground` for app woken up from background (where possibly the consent
     setting could be changed in system settings)
     */
    func checkConsentStates() {
        var consentsSettingsDefaults = SmartlookConsentSDK.ConsentsSettings()
        consentsSettingsDefaults.append((.privacy, .provided))
        consentsSettingsDefaults.append((.analytics, .notProvided))
        // adding a custom consent
        // consentsSettingsDefaults.append(("gdpr", .notProvided))

        SmartlookConsentSDK.check(with: consentsSettingsDefaults) {
            if SmartlookConsentSDK.consentState(for: .analytics) == .provided {
                // start analytics tools
                // Smartlook.start(withKey: "1a2b3c4e5f60")
            }
        }
    }

    // MARK: - Application lifecycle

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkConsentStates()
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        checkConsentStates()
    }
}
