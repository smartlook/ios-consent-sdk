//
//  PPCPViewController.swift
//  ConsentSDK
//
//  Created by Pavel Kroh on 13/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit
import SafariServices

protocol CSDKViewControllerDelegate {
    func viewControllerRequestClose(_ viewController: CSDKViewController)
}

class CSDKViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConsentCellDelegate {

   @IBOutlet weak var tableView: UITableView!
    
    public var delegate: CSDKViewControllerDelegate?
    
    public var consents = Dictionary<ConsentSDK.Consent, ConsentSDK.ConsentState>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consents.count + 2
    }
    
    func consentForIndex(_ index: Int) -> ConsentSDK.Consent? {
        return consents.keys.sorted()[index]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
        case consents.count + 1:
            return tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath)
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ConsentCell", for: indexPath) as? ConsentCell, let consent = consentForIndex(indexPath.item - 1), let defaultState = consents[consent] {
                cell.delegate = self
                cell.setupCell(consent, defaultState)
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
    
    private var safariController: SFSafariViewController?
    
    func consentCellDetailButtonPressed(cell: ConsentCell) {
        guard let consent = cell.consent, let url = consent.detailUrl() else {
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
