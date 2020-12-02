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

    @IBOutlet weak var buttonBackground: UIView!
    @IBOutlet weak var title: UILabel!

    // MARK: - View lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        buttonBackground.layer.cornerRadius = 6
        title.text = NSLocalizedString("\(SmartlookConsentSDK.keyPrefix)-button", comment: "")
    }
}
