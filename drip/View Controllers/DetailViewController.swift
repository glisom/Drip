//
//  DetailViewController.swift
//  drip
//
//  Created by Grant Isom on 8/13/19.
//  Copyright © 2019 Grant Isom. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    var coffee: Coffee!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        if let imageData = coffee.image {
            let image = UIImage(data: imageData)
            let headerView = UIImageView(image: image)
            headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
            headerView.contentMode = .scaleAspectFill
            tableView.tableHeaderView = headerView
            tableView.rowHeight = UITableView.automaticDimension
        }
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editCoffee))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func editCoffee() {
        performSegue(withIdentifier: "editCoffee", sender: self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Overview"
        }
        
        if section == 1 {
            return "History"
        }
        
        if section == 2 {
            return "Flavor Profile"
        }
        
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, indexPath.row == 0 {
            let cell = CoffeeOverviewCell(coffee)
            return cell
        }
        if indexPath.section == 1, indexPath.row == 0 {
            let cell = CoffeeHistoryCell(coffee)
            return cell
        }
        if indexPath.section == 2, indexPath.row == 0 {
            let cell = CoffeeChartCell(coffee)
            cell.layoutIfNeeded()
            return cell
        }

        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2, indexPath.row == 0 {
            return UIScreen.main.bounds.width
        }
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCoffee" {
            let editVC = segue.destination as! NewEntryController
            editVC.coffee = coffee
        }
    }
}
