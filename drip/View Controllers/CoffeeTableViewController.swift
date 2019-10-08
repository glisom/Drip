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
import Cosmos

class CoffeeViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let realm = try! Realm()
    var coffees: Results<Coffee>!
    var defaultColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        defaultColor = view.backgroundColor
        setUpNavigationController()
        loadEntries()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadEntries()
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
    
    func loadEntries() {
        var currentCount: Int
        currentCount = (coffees != nil) ? coffees.count : 0
        coffees = realm.objects(Coffee.self)
        if coffees.count > 0 {
            view.backgroundColor = defaultColor
            tableView.reloadData()
        } else {
            if (currentCount != coffees.count) {
                tableView.reloadData()
            }
            view.backgroundColor = .white
        }
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "placeholder")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.darkGray];
        return NSAttributedString(string: "Add a new coffee to get started!", attributes: attributes)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        if let imageData = coffee.image {
            cell.coffeeImageView?.image = UIImage(data: imageData)
            
            cell.coffeeImageView?.layer.masksToBounds = true
            cell.coffeeImageView?.layer.cornerRadius = 44
        } else {
            cell.coffeeImageView?.image = #imageLiteral(resourceName: "coffee-cup")
            cell.coffeeImageView?.contentMode = .scaleAspectFit
        }
        cell.starView.rating = Double(coffee.rating)
        cell.coffee = coffee
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
            realm.delete(coffees[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destination as! DetailViewController
            let cell = sender as! CoffeeTableViewCell
            detailVC.coffee = cell.coffee
        }
    }
    
    @IBAction func unwindToViewControllerNameHere(segue: UIStoryboardSegue) {
        loadEntries()
    }
    

}
