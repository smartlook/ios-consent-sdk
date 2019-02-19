//
//  TopBorderCell.swift
//  PrivacyControlPanel
//
//  Created by Pavel Kroh on 15/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit

class TopBorderCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(borderView)
        borderView.backgroundColor = UIColor.lightGray
        borderView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        borderView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }

}
