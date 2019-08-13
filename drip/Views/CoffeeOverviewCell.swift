//
//  CoffeeOverviewCell.swift
//  drip
//
//  Created by Grant Isom on 8/13/19.
//  Copyright © 2019 Grant Isom. All rights reserved.
//

import UIKit
import Cosmos

class CoffeeOverviewCell: UITableViewCell {
    convenience init(_ coffee: Coffee) {
        self.init()
        let nameLabel = UILabel()
        nameLabel.text = coffee.name
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title1).bold()
        contentView.addSubview(nameLabel)
        
        let roasterLabel = UILabel()
        roasterLabel.text = coffee.roaster
        roasterLabel.font = UIFont.preferredFont(forTextStyle: .title3).bold()
        contentView.addSubview(roasterLabel)
        
        let starView = CosmosView()
        starView.rating = Double(coffee.rating)
        contentView.addSubview(starView)
        
        let notesLabel = UILabel()
        notesLabel.text = coffee.notes
        notesLabel.font = UIFont.preferredFont(forTextStyle: .body).italic()
        notesLabel.textColor = .darkText
        notesLabel.numberOfLines = 0
        contentView.addSubview(notesLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        roasterLabel.translatesAutoresizingMaskIntoConstraints = false
        roasterLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        roasterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        roasterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        starView.translatesAutoresizingMaskIntoConstraints = false
        starView.topAnchor.constraint(equalTo: roasterLabel.bottomAnchor, constant: 10).isActive = true
        starView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        starView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        notesLabel.topAnchor.constraint(equalTo: starView.bottomAnchor, constant: 10).isActive = true
        notesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        notesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        notesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    }

}
