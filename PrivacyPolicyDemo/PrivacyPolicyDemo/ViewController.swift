//
//  ViewController.swift
//  PrivacyPolicyDemo
//
//  Created by Pavel Kroh on 15/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit
import PrivacyControlPanel

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        privacyConsentIndicator.layer.cornerRadius = 3
        analyticsConsentIndicator.layer.cornerRadius = 3

        updateConsentIndicators()

        if !PrivacyControlPanel.wasShown {
            showPrivacyControlPanel()
        }
    }
    
    func showPrivacyControlPanel() {
        // which policies consents are asked for, and default consent values
        var privacyControlPanelSettings = PrivacyControlPanelSetting()
        privacyControlPanelSettings[.privacy] = .notProvided
        privacyControlPanelSettings[.analytics] = .provided
        
        PrivacyControlPanel.show(for: privacyControlPanelSettings) {
            // here, read the current values from PrivacyControlPanel and act accordingly
            self.updateConsentIndicators()
        }
    }
    
    
    @IBAction func changePrivacySettings(_ sender: Any) {
        // let user review or check the consents
        showPrivacyControlPanel()
    }
    
    @IBOutlet weak var consentsWereShownIndicator: UILabel!
    @IBOutlet weak var privacyConsentIndicator: UIView!
    @IBOutlet weak var analyticsConsentIndicator: UIView!
    
    let consentColors: Dictionary<PrivacyControlPanel.ConsentState,UIColor> = [.unknown : UIColor.lightGray, .provided : UIColor.green.withAlphaComponent(0.5), .notProvided : UIColor.red]
    
    func updateConsentIndicators() {
       
        consentsWereShownIndicator.text = PrivacyControlPanel.wasShown ? "✅" : "❌"
        privacyConsentIndicator.backgroundColor = consentColors[PrivacyControlPanel.consent(for: .privacy)]
        analyticsConsentIndicator.backgroundColor = consentColors[PrivacyControlPanel.consent(for: .analytics)]
    }


}

