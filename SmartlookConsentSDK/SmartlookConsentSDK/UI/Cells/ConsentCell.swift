//
//  ConsentCell.swift
//  SmartlookConsentSDK
//
//  Created by Pavel Kroh on 15/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit

class ConsentCell: TopBorderCell {

    // MARK: - UI Outlets

    @IBOutlet weak var consentSwitch: UISwitch!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var detailView: UIView!

    // MARK: - Private

    private var consentUrl: URL?

    // MARK: - Public

    public weak var delegate: ConsentCellDelegate?
    private(set) var consent: SmartlookConsentSDK.Consent?

    func setupCell(_ consent: SmartlookConsentSDK.Consent, _ defaultState: SmartlookConsentSDK.ConsentState) {
        self.consent = consent

        if SmartlookConsentSDK.consentState(for: consent) == .unknown {
            // default default state is .provided
            SmartlookConsentSDK.set(state: defaultState == .unknown ? .provided : defaultState, for: consent)
        }
        consentSwitch.isOn = SmartlookConsentSDK.consentState(for: consent) == .provided
        label.text = SmartlookConsentSDK.label(for: consent)
        consentUrl = SmartlookConsentSDK.detailUrl(for: consent)
        detailView.isHidden = consentUrl == nil
    }

    // MARK: - UI Actions

    // the state is changed immediately
    @IBAction func switchAction(_ sender: Any) {
        if let consent = consent {
            SmartlookConsentSDK.set(state: consentSwitch.isOn ? .provided : .notProvided, for: consent)
            consentSwitch.isOn = SmartlookConsentSDK.consentState(for: consent) != .notProvided
        }
    }

    @IBAction func detailButtonAction(_ sender: Any) {
        delegate?.consentCellDetailButtonPressed(cell: self)
    }

    // MARK: - View lifecycle

    override func prepareForReuse() {
        consentUrl = nil
    }
}
