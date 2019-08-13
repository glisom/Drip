//
//  FlavorWheelEditViewController.swift
//  drip
//
//  Created by Isom,Grant on 5/22/18.
//  Copyright © 2018 Grant Isom. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class FlavorWheelEditViewController: FormViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var coffee: Coffee!
    
    let flavors = ["Sweet", "Sour/Tart", "Floral", "Spicy", "Salty", "Berry Fruit", "Citrus Fruit", "Stone Fruit", "Chocolate", "Caramel", "Smoky", "Bitter", "Savory", "Body", "Clean", "Linger/Finish"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let flavorProfile = coffee.flavorProfile {
            let jsonData = flavorProfile.data(using: .utf8)
            let flavorProfile = try! JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as! Dictionary<String, Float>
            
            form +++ Section("Flavor Profile")
            for flavor:String in flavors {
                form.last!
                    <<< SliderRow(flavor){ row in
                        row.title = flavor
                        row.steps = 5
                        row.value = flavorProfile[flavor]
                        }.cellSetup { cell, row in
                            cell.slider.minimumValue = 0
                            cell.slider.maximumValue = 5
                }
            }
        } else {
            form +++ Section("Flavor Profile")
            for flavor:String in flavors {
                form.last!
                    <<< SliderRow(flavor){ row in
                        row.title = flavor
                        row.steps = 5
                        row.value = 0
                        }.cellSetup { cell, row in
                            cell.slider.minimumValue = 0
                            cell.slider.maximumValue = 5
                }
            }
        }
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        let realm = try! Realm()
        if form.validate().count == 0 {
            try! realm.write {
                let jsonData = try? JSONSerialization.data(withJSONObject: form.values(), options: [.prettyPrinted])
                let jsonString = String(data: jsonData!, encoding: .utf8)
                coffee.flavorProfile =  jsonString!
            }
        }
        self.performSegue(withIdentifier: "unwindToStart", sender: self)
    }
    
}
