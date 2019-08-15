//
//  CoffeeHistoryCell.swift
//  drip
//
//  Created by Grant Isom on 8/13/19.
//  Copyright © 2019 Grant Isom. All rights reserved.
//

import UIKit

class CoffeeHistoryCell: UITableViewCell {
    
    convenience init(_ coffee: Coffee) {
        self.init()
        
        let roastedLabel = UILabel()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        roastedLabel.text = "Roasted on \(formatter.string(from: coffee.roastDate))"
        roastedLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        contentView.addSubview(roastedLabel)
        
        roastedLabel.translatesAutoresizingMaskIntoConstraints = false
        roastedLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        roastedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        
        if coffee.price != 0.0 {
            let priceLabel = UILabel()
            priceLabel.text = String(format: "$%.02f", coffee.price)
            priceLabel.font = UIFont.preferredFont(forTextStyle: .title3).bold()
            contentView.addSubview(priceLabel)
            
            priceLabel.translatesAutoresizingMaskIntoConstraints = false
            priceLabel.topAnchor.constraint(equalTo: roastedLabel.bottomAnchor, constant: 10).isActive = true
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        }
    }

}
