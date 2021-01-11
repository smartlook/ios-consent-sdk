//
//  ViewController.swift
//  ConsentSDKDemo
//
//  Created by Pavel Kroh on 18/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit
import SmartlookConsentSDK

class MainViewController: UIViewController {

    // MARK: - UI Outlets

    @IBOutlet weak var consentPanelWasShown: UIView!
    @IBOutlet weak var privacyConsentIndicator: UIView!
    @IBOutlet weak var analyticsConsentIndicator: UIView!

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        privacyConsentIndicator.layer.cornerRadius = 3
        analyticsConsentIndicator.layer.cornerRadius = 3

        // This is not necessary if all the logic is handled in the `SmartlookConsentSDK.check`
        // or `SmartlookConsentSDK.show` callbacks may be usefully eg.,
        // if some UI depends on the consents state like here.
        let notificationName = SmartlookConsentSDK.consentsTouchedNotification
        _ = NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { (_) in
            self.updateConsentIndicators()
        }

        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = UIColor.white
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateConsentIndicators()
    }

    // MARK: - Consent state visualization

    let consentColors: [SmartlookConsentSDK.ConsentState: UIColor] = [
        .unknown: UIColor.lightGray,
        .provided: UIColor.green,
        .notProvided: UIColor.red
    ]

    func updateConsentIndicators() {
        consentPanelWasShown.backgroundColor = SmartlookConsentSDK.wasShown ? UIColor.green : UIColor.red
        privacyConsentIndicator.backgroundColor = consentColors[SmartlookConsentSDK.consentState(for: .privacy)]
        analyticsConsentIndicator.backgroundColor = consentColors[SmartlookConsentSDK.consentState(for: .analytics)]
    }

    // MARK: - UI Actions

    @IBAction func reviewConsents(_ sender: Any) {
        // let user review or check the consents
        SmartlookConsentSDK.show {
            self.updateConsentIndicators()
            if SmartlookConsentSDK.consentState(for: .analytics) != .provided {
                // stop analytics tools
            }
        }
    }

    @IBAction func showAppSettingsAction(_ sender: Any) {
        if
            let settingsUrl = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settingsUrl)
        {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
}
