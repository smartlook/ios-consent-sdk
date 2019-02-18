//
//  ViewController.swift
//  ConsentSDKDemo
//
//  Created by Pavel Kroh on 18/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit
import ConsentSDK

class ViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()

        privacyConsentIndicator.layer.cornerRadius = 3
        analyticsConsentIndicator.layer.cornerRadius = 3
        
        updateConsentIndicators()
        
        var consentsSettingsDefaults = ConsentSDK.ConsentsSettings()
        consentsSettingsDefaults.append((.privacy, .provided))
        consentsSettingsDefaults.append((.analytics, .notProvided))
        consentsSettingsDefaults.append(("gdpr", .notProvided))

        ConsentSDK.check(with: consentsSettingsDefaults) {
            self.updateConsentIndicators()
            if ConsentSDK.consentState(for: .analytics) == .provided {
                // start analytics tools
            }
        }
    }
    
    @IBAction func reviewConsents(_ sender: Any) {
        // let user review or check the consents
        ConsentSDK.show {
            self.updateConsentIndicators()
            if ConsentSDK.consentState(for: .analytics) != .provided {
                // stop analytics tools
            }
        }
    }
    
    @IBOutlet weak var consentPanelWasShown: UIView!
    @IBOutlet weak var privacyConsentIndicator: UIView!
    @IBOutlet weak var analyticsConsentIndicator: UIView!
    
    let consentColors: Dictionary<ConsentSDK.ConsentState,UIColor> = [.unknown : UIColor.lightGray, .provided : UIColor.green, .notProvided : UIColor.red]
    
    func updateConsentIndicators() {
        consentPanelWasShown.backgroundColor = ConsentSDK.wasShown ? UIColor.green : UIColor.red
        privacyConsentIndicator.backgroundColor = consentColors[ConsentSDK.consentState(for: .privacy)]
        analyticsConsentIndicator.backgroundColor = consentColors[ConsentSDK.consentState(for: .analytics)]
    }
    

}

