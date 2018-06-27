//
//  Models.swift
//  drip
//
//  Created by Isom,Grant on 5/24/18.
//  Copyright © 2018 Grant Isom. All rights reserved.
//

import UIKit

class Coffee: NSObject {
    @objc dynamic var name = ""
    @objc dynamic var roaster = ""
    @objc dynamic var producer = ""
    @objc dynamic var roastDate = NSDate()
    @objc dynamic var brewDate = NSDate()
    @objc dynamic var beverage = ""
    @objc dynamic var price = Double()
    @objc dynamic var notes = ""
    @objc dynamic var rating = Int()
    @objc dynamic var brewMethod = ""
    @objc dynamic var flavorProfile = FlavorProfile()
}

class FlavorProfile: NSObject {
    @objc dynamic var sweet = Int()
    @objc dynamic var sourTart = Int()
    @objc dynamic var floral = Int()
    @objc dynamic var spicy = Int()
    @objc dynamic var salty = Int()
    @objc dynamic var berryFruit = Int()
    @objc dynamic var citrusFruit = Int()
    @objc dynamic var stoneFruit = Int()
    @objc dynamic var chocolate = Int()
    @objc dynamic var caramel = Int()
    @objc dynamic var smoky = Int()
    @objc dynamic var bitter = Int()
    @objc dynamic var savory = Int()
    @objc dynamic var body = Int()
    @objc dynamic var clean = Int()
    @objc dynamic var lingerFinish = Int()
}
