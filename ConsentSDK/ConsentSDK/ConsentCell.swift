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
    
    var consent: ConsentSDK.Consent?
    
    func setupCell(_ consent_: ConsentSDK.Consent, _ defaultState_: ConsentSDK.ConsentState) {
        consent = consent_
        if let consent = consent {
            if ConsentSDK.consentState(for: consent) == .unknown {
                // default default state is .provided
                ConsentSDK.set(state: defaultState_ == .unknown ? .provided : defaultState_, for: consent)
            }
            consentSwitch.isOn = ConsentSDK.consentState(for: consent) == .provided
            label.text = ConsentSDK.label(for: consent)
            consentUrl = ConsentSDK.detailUrl(for: consent)
            detailView.isHidden = consentUrl == nil
        }
    }
    
    // the state is changed immediatelly
    @IBAction func switchAction(_ sender: Any) {
        if let consent = consent {
            ConsentSDK.set(state: consentSwitch.isOn ? .provided : .notProvided, for: consent)
            consentSwitch.isOn = ConsentSDK.consentState(for: consent) != .notProvided
        }
    }
    
    override func prepareForReuse() {
        consentUrl = nil
    }
    
    @IBAction func detailButtonAction(_ sender: Any) {
        delegate?.consentCellDetailButtonPressed(cell: self)
    }
}

