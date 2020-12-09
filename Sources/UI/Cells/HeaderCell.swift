//
//  HeaderCell.swift
//  SmartlookConsentSDK
//
//  Created by Pavel Kroh on 15/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    // MARK: - UI Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!

    // MARK: - View lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        fillContent()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        fillContent()
    }

    // MARK: - Content

    private func fillContent() {
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
        var titleText = NSLocalizedString("\(SmartlookConsentSDK.keyPrefix)-title", comment: "")
        titleText = titleText.replacingOccurrences(of: "$APP", with: appName)

        let titleStyles = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)]
        let attributedString = NSMutableAttributedString(string: titleText, attributes: titleStyles)

        if let appNameRange = titleText.range(of: appName), !appNameRange.isEmpty {
            let appNameColor = tintColor ?? UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
            let appNameAttributes = [NSAttributedString.Key.foregroundColor: appNameColor]
            attributedString.setAttributes(appNameAttributes, range: NSRange(appNameRange, in: titleText))
        }

        titleLabel.attributedText = attributedString
        infoLabel.text = NSLocalizedString("\(SmartlookConsentSDK.keyPrefix)-text", comment: "")
    }
}
