//
//  TableViewCell.swift
//  Privacy-Policy-Control-Panel
//
//  Created by Pavel Kroh on 15/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit

protocol ConsentCellDelegate: class {
    func consentCellDetailButtonPressed(cell: ConsentCell)
}

class ConsentCell: TopBorderCell {
    
    @IBOutlet weak var consentSwitch: UISwitch!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var detailView: UIView!
    
    public weak var delegate: ConsentCellDelegate?
    
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
            detailView.isHidden = consentUrl == nil
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
    
    @IBAction func detailButtonAction(_ sender: Any) {
        delegate?.consentCellDetailButtonPressed(cell: self)
    }
}

