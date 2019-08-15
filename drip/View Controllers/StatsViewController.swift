//
//  StatsViewController.swift
//  drip
//
//  Created by Grant Isom on 8/14/19.
//  Copyright © 2019 Grant Isom. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

class StatsViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let realm = try! Realm()
    var coffees: Results<Coffee>!
    var defaultColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        setUpNavigationController()
        defaultColor = view.backgroundColor
        loadEntries()
    }
    
    func setUpNavigationController() {
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
        if coffees.count > 0 {
            view.backgroundColor = defaultColor
            tableView.reloadData()
        } else {
            view.backgroundColor = .white
        }
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "graph")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.darkGray];
        return NSAttributedString(string: "Add a new coffee to see statistics.", attributes: attributes)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffees.count > 0 ? 5 : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StatCell(coffees, .overall)
        return cell
    }
}
