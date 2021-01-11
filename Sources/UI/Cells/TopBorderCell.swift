//
//  TopBorderCell.swift
//  SmartlookConsentSDK
//
//  Created by Pavel Kroh on 15/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit

class TopBorderCell: UITableViewCell {

    // MARK: - View lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(borderView)

        var separatorColor: UIColor = .lightGray
        if #available(iOS 13.0, *) {
            separatorColor = .separator
        }
        borderView.backgroundColor = separatorColor
        borderView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        borderView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
}
