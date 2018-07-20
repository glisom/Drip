//
//  CoffeeTableViewCell.swift
//  drip
//
//  Created by Isom,Grant on 7/19/18.
//  Copyright © 2018 Grant Isom. All rights reserved.
//

import UIKit

class CoffeeTableViewCell: UITableViewCell {

    @IBOutlet weak var coffeeImageView: UIImageView!
    @IBOutlet weak var coffeeTitleLabel: UILabel!
    @IBOutlet weak var coffeeSubtitleLabel: UILabel!
    @IBOutlet weak var brewDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var coffee:Coffee!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
