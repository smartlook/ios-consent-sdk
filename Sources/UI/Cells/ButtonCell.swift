//
//  ButtonCell.swift
//  SmartlookConsentSDK
//
//  Created by Pavel Kroh on 15/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit

class ButtonCell: TopBorderCell {

    // MARK: - UI Outlets

    @IBOutlet weak var button: UIButton!

    // MARK: - Public

    public weak var delegate: ButtonCellDelegate?

    // MARK: - UI Actions

    @IBAction func detailButtonAction(_ sender: Any) {
        if let button = sender as? UIButton {
            delegate?.buttonCellPressed(button: button)
        }
    }

    // MARK: - View lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        button.layer.cornerRadius = 6
        button.setTitleColor(.white, for: .normal)

        let buttonTitle = NSLocalizedString("\(SmartlookConsentSDK.keyPrefix)-button", comment: "")
        button.setTitle(buttonTitle, for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        button.backgroundColor = tintColor
    }
}
