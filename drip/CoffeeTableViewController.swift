//
//  CoffeeTableViewController.swift
//  drip
//
//  Created by Isom,Grant on 7/12/18.
//  Copyright © 2018 Grant Isom. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RealmSwift

class CoffeeTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let realm = try! Realm()
    var coffees: Results<Coffee>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        
        loadEntries()
    }
    
    func loadEntries() {
        coffees = realm.objects(Coffee.self)
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty_placeholder")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.darkGray];
        return NSAttributedString(string: "Add a new coffee to get started!", attributes: attributes)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return coffees.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coffeeCell", for: indexPath) as! CoffeeTableViewCell

        let coffee:Coffee = coffees[indexPath.row]
        
        cell.coffeeTitleLabel?.text = coffee.name
        cell.coffeeSubtitleLabel?.text = coffee.roaster
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        cell.brewDateLabel.text = formatter.string(from: coffee.brewDate)
        
        cell.coffeeImageView?.image = UIImage.init(data: coffee.image)
        cell.coffeeImageView?.contentMode = UIViewContentMode.scaleAspectFill
        cell.coffeeImageView?.layer.masksToBounds = true
        cell.coffeeImageView?.layer.cornerRadius = 49
        cell.descriptionLabel.text = coffee.notes
        cell.coffee = coffee
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destination as! DetailViewController
            let cell = sender as! CoffeeTableViewCell
            detailVC.coffee = cell.coffee
        }
    }
    
    @IBAction func unwindToViewControllerNameHere(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
    

}
