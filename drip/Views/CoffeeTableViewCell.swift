//
//  CoffeeTableViewCell.swift
//  drip
//
//  Created by Isom,Grant on 7/19/18.
//  Copyright © 2018 Grant Isom. All rights reserved.
//

import UIKit
import QuartzCore
import Cosmos

class CoffeeTableViewCell: UITableViewCell {

    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var coffeeImageView: UIImageView!
    @IBOutlet weak var coffeeTitleLabel: UILabel!
    @IBOutlet weak var coffeeSubtitleLabel: UILabel!
    @IBOutlet weak var brewDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var coffee:Coffee!
}
