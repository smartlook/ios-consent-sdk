//
//  ButtonCell.swift
//  Privacy-Policy-Control-Panel
//
//  Created by Pavel Kroh on 15/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 4
        title.text = NSLocalizedString("\(PrivacyControlPanel.keyPrefix)-button", comment: "")
    }
}

