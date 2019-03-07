//
//  PPCPViewController.swift
//  ConsentSDK
//
//  Created by Pavel Kroh on 13/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit
import SafariServices

protocol SLCViewControllerDelegate {
    func viewControllerRequestClose(_ viewController: ViewController)
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConsentCellDelegate {

   @IBOutlet weak var tableView: UITableView!
    
    public var delegate: SLCViewControllerDelegate?
    
    public var consents = SmartlookConsentSDK.ConsentsSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consents.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
        case consents.count + 1:
            return tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath)
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ConsentCell", for: indexPath) as? ConsentCell {
                cell.delegate = self
                let consentDef = consents[indexPath.item - 1]
                cell.setupCell(consentDef.consent, consentDef.defaultState)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.item == consents.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // this could be only the button
        delegate?.viewControllerRequestClose(self)
    }
       
    func consentCellDetailButtonPressed(cell: ConsentCell) {
        guard let consent = cell.consent, let url = SmartlookConsentSDK.detailUrl(for: consent) else {
            return
        }
        var safariController: SFSafariViewController?
        if #available(iOS 11, *) {
            let config = SFSafariViewController.Configuration()
            config.barCollapsingEnabled = false
            safariController = SFSafariViewController(url: url, configuration: config)
            safariController?.dismissButtonStyle = .done
        } else {
            safariController = SFSafariViewController(url: url)
        }
        if let safariController = safariController {
            safariController.modalPresentationStyle = .formSheet
            safariController.modalTransitionStyle = .crossDissolve
        }
        if let safariController = safariController {
            present(safariController, animated: true, completion: nil)
        }
    }
    
}
