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
        
        updateConsentIndicators()
        
        var consentsSettingsDefaults = SmartlookConsentSDK.ConsentsSettings()
        consentsSettingsDefaults.append((.privacy, .provided))
        consentsSettingsDefaults.append((.analytics, .notProvided))
        //consentsSettingsDefaults.append(("gdpr", .notProvided))   // adding a custom consent

        SmartlookConsentSDK.check(with: consentsSettingsDefaults) {
            self.updateConsentIndicators()
            if SmartlookConsentSDK.consentState(for: .analytics) == .provided {
                // start analytics tools
            }
        }
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
    

}

