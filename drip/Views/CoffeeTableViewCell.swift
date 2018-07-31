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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.masksToBounds = false;
        cardView.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        cardView.layer.shadowRadius = 3
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        cardView.layer.shadowOpacity = 0.4
        cardView.layer.cornerRadius = 3
        let radius = cardView.layer.cornerRadius
        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: radius).cgPath
        
        coffeeImageView.layer.borderWidth = 3
        coffeeImageView.layer.borderColor = UIColor.lightText.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
