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
    @objc dynamic var name: String?
    @objc dynamic var roaster: String?
    @objc dynamic var roastDate = Date()
    @objc dynamic var brewDate = Date()
    @objc dynamic var beverage: String?
    @objc dynamic var price = Double()
    @objc dynamic var notes: String?
    @objc dynamic var rating = Float()
    @objc dynamic var brewMethod: String?
    @objc dynamic var image: Data?
    @objc dynamic var flavorProfile: String?
}
