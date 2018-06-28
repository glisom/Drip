//
//  FirstViewController.swift
//  drip
//
//  Created by Isom,Grant on 5/18/18.
//  Copyright © 2018 Grant Isom. All rights reserved.
//

import UIKit
import Eureka
import ImageRow

class NewEntryController: FormViewController {
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("General Info")
            <<< TextRow("name"){ row in
                row.title = "Coffee Origin/Name"
            }
            <<< TextRow("roaster"){ row in
                row.title = "Roaster"
            }
            <<< TextRow("producer"){ row in
                row.title = "Producer"
            }
            <<< DateRow("roast_date"){ row in
                row.title = "Roast Date"
                row.value = Date()
            }
            <<< DateRow("brew_date"){ row in
                row.title = "Brew Date"
                row.value = Date()
            }
            <<< TextRow("beverage"){ row in
                row.title = "Beverage"
            }
            <<< DecimalRow("price"){ row in
                row.title = "Price"
                row.useFormatterDuringInput = true
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                row.formatter = formatter
            }
            <<< PushRow<String>("brew_method") {
                $0.title = "Brew Method"
                $0.options = ["Cupping", "Drip", "Espresso", "Pour Over", "Press", "Siphon", "Other"]
                $0.selectorTitle = "Brew Method"
                }.onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
            }
            <<< SliderRow("rating"){ row in
                row.title = "Rating"
                row.maximumValue = 5
                row.minimumValue = 0
                row.steps = 5
                row.value = 0
            }
            <<< ImageRow("image") { row in
                row.title = "Add image of coffee or bag."
            }
            +++ Section("Notes")
            <<< TextAreaRow("notes"){ row in
            }
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        if form.validate().count == 0 {
            
            // Add values to shared instance while creating flavor wheel
            Session.sharedInstance.name = form.values()["name"] as! String
            Session.sharedInstance.roaster = form.values()["roaster"] as! String
            Session.sharedInstance.producer = form.values()["producer"] as! String
            Session.sharedInstance.roastDate = form.values()["roast_date"] as! Date
            Session.sharedInstance.brewDate = form.values()["brew_date"] as! Date
            Session.sharedInstance.beverage = form.values()["beverage"] as! String
            Session.sharedInstance.price = form.values()["price"] as! Double
            Session.sharedInstance.brewMethod = form.values()["brew_method"] as! String
            Session.sharedInstance.rating = form.values()["rating"] as! Float
            Session.sharedInstance.image = UIImageJPEGRepresentation(form.values()["image"] as! UIImage, 1.0)!
            Session.sharedInstance.notes = form.values()["notes"] as! String
            
            performSegue(withIdentifier: "showFlavorWheelEdit", sender: self)
        }
        
        
    }

    class CurrencyFormatter : NumberFormatter, FormatterProtocol {
        override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
            guard obj != nil else { return }
            var str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            if !string.isEmpty, numberStyle == .currency && !string.contains(currencySymbol) {
                // Check if the currency symbol is at the last index
                if let formattedNumber = self.string(from: 1), String(formattedNumber[formattedNumber.index(before: formattedNumber.endIndex)...]) == currencySymbol {
                    // This means the user has deleted the currency symbol. We cut the last number and then add the symbol automatically
                    str = String(str[..<str.index(before: str.endIndex)])
                    
                }
            }
            obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
        }
        
        func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
            return textInput.position(from: position, offset:((newValue?.count ?? 0) - (oldValue?.count ?? 0))) ?? position
        }
    }


}

