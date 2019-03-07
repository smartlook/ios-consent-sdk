//
//  ViewController.swift
//  ConsentSDKDemo
//
//  Created by Pavel Kroh on 18/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit
import SmartlookConsentSDK

class ViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()

        privacyConsentIndicator.layer.cornerRadius = 3
        analyticsConsentIndicator.layer.cornerRadius = 3
    
        // this is not necessary if all the logic is handled in the `SmartlookConsentSDK.check` or `SmartlookConsentSDK.show` callbacks
        // may be usefull eg., if some UI depends on the consents state like here
        NotificationCenter.default.addObserver(forName: SmartlookConsentSDK.consentsTouchedNotification, object: nil, queue: nil) { (notif) in
            self.updateConsentIndicators()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateConsentIndicators()
    }
    
    @IBAction func reviewConsents(_ sender: Any) {
        // let user review or check the consents
        SmartlookConsentSDK.show {
            self.updateConsentIndicators()
            if SmartlookConsentSDK.consentState(for: .analytics) != .provided {
                // stop analytics tools
            }
        }
    }
    
    @IBOutlet weak var consentPanelWasShown: UIView!
    @IBOutlet weak var privacyConsentIndicator: UIView!
    @IBOutlet weak var analyticsConsentIndicator: UIView!
    
    let consentColors: Dictionary<SmartlookConsentSDK.ConsentState,UIColor> = [.unknown : UIColor.lightGray, .provided : UIColor.green, .notProvided : UIColor.red]
    
    func updateConsentIndicators() {
        consentPanelWasShown.backgroundColor = SmartlookConsentSDK.wasShown ? UIColor.green : UIColor.red
        privacyConsentIndicator.backgroundColor = consentColors[SmartlookConsentSDK.consentState(for: .privacy)]
        analyticsConsentIndicator.backgroundColor = consentColors[SmartlookConsentSDK.consentState(for: .analytics)]
    }
    
    @IBAction func showAppSettingsAction(_ sender: Any) {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler:nil)
        }
    }

}

