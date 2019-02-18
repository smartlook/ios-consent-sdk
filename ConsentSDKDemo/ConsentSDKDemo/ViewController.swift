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
        
        if !ConsentSDK.wasShown {
            showPrivacyControlPanel()
        }
    }
    
    func showPrivacyControlPanel() {
        // which policies consents are asked for, and default consent values
        var privacyControlPanelSettings = CSDKControlPanelSetting()
        privacyControlPanelSettings[.privacy] = .notProvided
        privacyControlPanelSettings[.analytics] = .provided
        
        ConsentSDK.show(with: privacyControlPanelSettings) {
            // here, read the current values from PrivacyControlPanel and act accordingly
            self.updateConsentIndicators()
        }
    }
    
    
    @IBAction func reviewConsents(_ sender: Any) {
        // let user review or check the consents
        showPrivacyControlPanel()
    }
    
    @IBOutlet weak var consentPanelWasShown: UIView!
    @IBOutlet weak var privacyConsentIndicator: UIView!
    @IBOutlet weak var analyticsConsentIndicator: UIView!
    
    let consentColors: Dictionary<ConsentSDK.ConsentState,UIColor> = [.unknown : UIColor.lightGray, .provided : UIColor.green, .notProvided : UIColor.red]
    
    func updateConsentIndicators() {
        
        consentPanelWasShown.backgroundColor = ConsentSDK.wasShown ? UIColor.green : UIColor.red
        privacyConsentIndicator.backgroundColor = consentColors[ConsentSDK.consent(for: .privacy)]
        analyticsConsentIndicator.backgroundColor = consentColors[ConsentSDK.consent(for: .analytics)]
    }
    

}

