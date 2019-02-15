//
//  TableViewCell.swift
//  Privacy-Policy-Control-Panel
//
//  Created by Pavel Kroh on 15/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit

class ConsentCell: UITableViewCell {
    
    @IBOutlet weak var consentSwitch: UISwitch!
    @IBOutlet weak var label: UILabel!
    
    private var consentUrl: URL?
    
    var consent: PrivacyControlPanel.Consent?
    
    func setupCell(_ consent_: PrivacyControlPanel.Consent, _ defaultState_: PrivacyControlPanel.ConsentState) {
        consent = consent_
        if var consent = consent {
            if consent.state == .unknown {
                // default default state is .provided
                consent.state = defaultState_ == .unknown ? .provided : defaultState_
            }
            consentSwitch.isOn = consent.state == .provided
            label.text = consent.label()
            consentUrl = consent.detailUrl()
            accessoryType = consentUrl == nil ? .none : .detailButton
        }
    }
    
    // the state is changed immediatelly
    @IBAction func switchAction(_ sender: Any) {
        if var consent = consent {
            consent.state = consentSwitch.isOn ? .provided : .notProvided
            consentSwitch.isOn = consent.state != .notProvided
        }
    }
    
    override func prepareForReuse() {
        consentUrl = nil
    }
    
}

