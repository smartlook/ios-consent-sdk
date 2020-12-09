//
//  ControlPanelViewController.swift
//  SmartlookConsentSDK
//
//  Created by Pavel Kroh on 13/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

import UIKit
import SafariServices

protocol SLCViewControllerDelegate: AnyObject {
    func viewControllerRequestClose(_ viewController: ControlPanelViewController)
}

class ControlPanelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - UI Outlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Public

    public weak var delegate: SLCViewControllerDelegate?
    public var consents = SmartlookConsentSDK.ConsentsSettings()

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: - UITableViewDataSource methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consents.count + 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)

        case consents.count + 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as? ButtonCell {
                cell.delegate = self
                return cell
            }

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

    // MARK: - UITableViewDelegate methods

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.item == consents.count + 1
    }
}

extension ControlPanelViewController: ConsentCellDelegate {

    // MARK: - ConsentCellDelegate methods

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

        safariController?.modalPresentationStyle = .formSheet
        safariController?.modalTransitionStyle = .crossDissolve

        if let safariController = safariController {
            present(safariController, animated: true, completion: nil)
        }
    }
}

extension ControlPanelViewController: ButtonCellDelegate {

    // MARK: - ButtonCellDelegate methods

    func buttonCellPressed(button: UIButton) {
        delegate?.viewControllerRequestClose(self)
    }
}
