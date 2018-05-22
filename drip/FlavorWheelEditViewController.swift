//
//  FlavorWheelEditViewController.swift
//  drip
//
//  Created by Isom,Grant on 5/22/18.
//  Copyright © 2018 Grant Isom. All rights reserved.
//

import UIKit
import Eureka

class FlavorWheelEditViewController: FormViewController {
    
    let flavors = ["Sweet", "Sour/Tart", "Floral", "Spicy", "Salty", "Berry Fruit", "Citrus Fruit", "Stone Fruit", "Chocolate", "Caramel", "Smoky", "Bitter", "Savory", "Body", "Clean", "Linger/Finish"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Flavor Wheel")
        for flavor:String in flavors {
            form.last!
             <<< SliderRow(){ row in
                row.title = flavor
                row.maximumValue = 5
                row.minimumValue = 0
                row.steps = 5
                row.value = 0
            }
        }
    }


}
