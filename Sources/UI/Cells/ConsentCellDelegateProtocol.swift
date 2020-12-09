//
//  ConsentCellDelegateProtocol.swift
//  SmartlookConsentSDK
//
//  Created by Václav Halík on 01.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

protocol ConsentCellDelegate: AnyObject {
    func consentCellDetailButtonPressed(cell: ConsentCell)
}
