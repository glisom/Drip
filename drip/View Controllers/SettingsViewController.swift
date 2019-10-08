//
//  SettingsViewController.swift
//  drip
//
//  Created by Isom,Grant on 7/31/18.
//  Copyright © 2018 Grant Isom. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices

class SettingsViewController: UITableViewController {
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var clearEntriesCell: UITableViewCell!
    @IBOutlet weak var requestFeatureCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = version
        }
        setUpNavigationController()
    }
    
    func setUpNavigationController() {
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor(red:0.05, green:0.16, blue:0.29, alpha:1.00)
        navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor(red:0.05, green:0.16, blue:0.29, alpha:1.00)
        navigationController?.navigationBar.hideBottomHairline()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo-text"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell == clearEntriesCell {
            let areYouSureAlert = UIAlertController(title: "Are you sure?", message: "This will remove all your entries.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Clear", style: .destructive) { _ in
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            areYouSureAlert.addAction(confirmAction)
            areYouSureAlert.addAction(cancelAction)
            present(areYouSureAlert, animated: true, completion: nil)
        }
        if cell == requestFeatureCell {
            let url = URL(string: "https://www.grantisom.com/contact")
            if let url = url {
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true, completion: nil)
            }
        }
    }
}
