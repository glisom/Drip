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

class CoffeeTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let realm = try! Realm()
    var coffees: Results<Coffee>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        
        setUpNavigationController()
        loadEntries()
    }
    
    func setUpNavigationController() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.lightGray
        navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGray
        navigationController?.navigationBar.hideBottomHairline()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo-text"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        
    }
    
    func loadEntries() {
        coffees = realm.objects(Coffee.self)
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
        cell.coffeeImageView?.contentMode = UIView.ContentMode.scaleAspectFill
        cell.coffeeImageView?.layer.masksToBounds = true
        cell.coffeeImageView?.layer.cornerRadius = 44
        cell.starView.rating = Double(coffee.rating)
        cell.coffee = coffee
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

extension UINavigationBar {
    func hideBottomHairline() {
        hairlineImageView?.isHidden = true
    }
    
    func showBottomHairline() {
        hairlineImageView?.isHidden = false
    }
}

extension UIToolbar {
    func hideBottomHairline() {
        hairlineImageView?.isHidden = true
    }
    
    func showBottomHairline() {
        hairlineImageView?.isHidden = false
    }
}

extension UIView {
    fileprivate var hairlineImageView: UIImageView? {
        return hairlineImageView(in: self)
    }
    
    fileprivate func hairlineImageView(in view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView, imageView.bounds.height <= 1.0 {
            return imageView
        }
        
        for subview in view.subviews {
            if let imageView = hairlineImageView(in: subview) { return imageView }
        }
        
        return nil
    }
}
