//
//  Models.swift
//  drip
//
//  Created by Isom,Grant on 5/24/18.
//  Copyright © 2018 Grant Isom. All rights reserved.
//

import UIKit
import RealmSwift

class Coffee: Object {
    @objc dynamic var name = ""
    @objc dynamic var roaster = ""
    @objc dynamic var producer = ""
    @objc dynamic var roastDate = Date()
    @objc dynamic var brewDate = Date()
    @objc dynamic var beverage = ""
    @objc dynamic var price = Double()
    @objc dynamic var notes = ""
    @objc dynamic var rating = Float()
    @objc dynamic var brewMethod = ""
    @objc dynamic var image = Data()
    @objc dynamic var flavorProfile = ""
}
