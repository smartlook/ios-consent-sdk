//
//  ButtonCellDelegateProtocol.swift
//  SmartlookConsentSDK
//
//  Created by Václav Halík on 04.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit

protocol ButtonCellDelegate: AnyObject {
    func buttonCellPressed(button: UIButton)
}
