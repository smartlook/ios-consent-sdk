//
//  HeaderCell.swift
//  Privacy-Policy-Control-Panel
//
//  Created by Pavel Kroh on 15/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
            let titleText = NSLocalizedString("\(PrivacyControlPanel.keyPrefix)-title", comment: "")
            titleLabel.text = titleText.replacingOccurrences(of: "$APP", with: appName)
            infoLabel.text = NSLocalizedString("\(PrivacyControlPanel.keyPrefix)-text", comment: "")
    }

}
