//
//  TableViewCell.swift
//  ConsentSDK
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
    
    var consent: SmartlookConsentSDK.Consent?
    
    func setupCell(_ consent_: SmartlookConsentSDK.Consent, _ defaultState_: SmartlookConsentSDK.ConsentState) {
        consent = consent_
        if let consent = consent {
            if SmartlookConsentSDK.consentState(for: consent) == .unknown {
                // default default state is .provided
                SmartlookConsentSDK.set(state: defaultState_ == .unknown ? .provided : defaultState_, for: consent)
            }
            consentSwitch.isOn = SmartlookConsentSDK.consentState(for: consent) == .provided
            label.text = SmartlookConsentSDK.label(for: consent)
            consentUrl = SmartlookConsentSDK.detailUrl(for: consent)
            detailView.isHidden = consentUrl == nil
        }
    }
    
    // the state is changed immediatelly
    @IBAction func switchAction(_ sender: Any) {
        if let consent = consent {
            SmartlookConsentSDK.set(state: consentSwitch.isOn ? .provided : .notProvided, for: consent)
            consentSwitch.isOn = SmartlookConsentSDK.consentState(for: consent) != .notProvided
        }
    }
    
    override func prepareForReuse() {
        consentUrl = nil
    }
    
    @IBAction func detailButtonAction(_ sender: Any) {
        delegate?.consentCellDetailButtonPressed(cell: self)
    }
}

