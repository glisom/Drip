//
//  NewEntryController.swift
//  drip
//
//  Created by Isom,Grant on 5/18/18.
//  Copyright © 2018 Grant Isom. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import SwiftMessages

class NewEntryController: FormViewController {
    @IBOutlet weak var nextButton: UIBarButtonItem!
    var coffee: Coffee!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coffee = Coffee()
        
        form +++ Section("General Info")
            <<< TextRow("name"){ row in
                row.value = ""
                row.title = "Coffee Origin/Name"
                var rules = RuleSet<String>()
                rules.add(rule: RuleRequired())
                row.add(ruleSet: rules)
            }
            <<< TextRow("roaster"){ row in
                row.value = ""
                row.title = "Roaster"
            }
            <<< TextRow("producer"){ row in
                row.value = ""
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
                row.value = ""
                row.title = "Beverage"
            }
            <<< DecimalRow("price"){ row in
                row.value = 0.00
                row.title = "Price"
                row.useFormatterDuringInput = true
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                row.formatter = formatter
            }
            <<< PushRow<String>("brew_method") {
                $0.value = ""
                $0.title = "Brew Method"
                $0.options = ["Cupping", "Drip", "Espresso", "Pour Over", "Press", "Siphon", "Other"]
                $0.selectorTitle = "Brew Method"
                }.onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
            }
            <<< SliderRow("rating"){ row in
                row.title = "Rating"
                row.steps = 5
                row.value = 0
                }.cellSetup { cell, row in
                    cell.slider.minimumValue = 0
                    cell.slider.maximumValue = 5
            }
            <<< ImageRow("image") { row in
                row.value = UIImage()
                row.title = "Add image of coffee or bag."
            }
            +++ Section("Notes")
            <<< TextAreaRow("notes"){ row in
                row.value = ""
            }
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        if form.validate().count == 0 {
            // Add values to shared instance while creating flavor wheel
            isNil(form.values()["name"]) ? () : (coffee.name = form.values()["name"] as! String)
            isNil(form.values()["roaster"]) ? () : (coffee.roaster = form.values()["roaster"] as! String)
            isNil(form.values()["producer"]) ? () : (coffee.producer = form.values()["producer"] as! String)
            isNil(form.values()["roast_date"]) ? () : (coffee.roastDate = form.values()["roast_date"] as! Date)
            isNil(form.values()["brew_date"]) ? () : (coffee.brewDate = form.values()["brew_date"] as! Date)
            isNil(form.values()["beverage"]) ? () : (coffee.beverage = form.values()["beverage"] as! String)
            isNil(form.values()["price"]) ? () : (coffee.price = form.values()["price"] as! Double)
            isNil(form.values()["brew_method"]) ? () : (coffee.brewMethod = form.values()["brew_method"] as! String)
            isNil(form.values()["rating"]) ? () : (coffee.rating = form.values()["rating"] as! Float)
            if let imageData = UIImageJPEGRepresentation(form.values()["image"] as! UIImage, 1.0) {
                coffee.image = imageData
            }
            isNil(form.values()["notes"]) ? () : (coffee.notes = form.values()["notes"] as! String)
            
            performSegue(withIdentifier: "showFlavorWheelEdit", sender: coffee)
        } else {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.warning)
            view.configureDropShadow()
            let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
            view.configureContent(title: "Whoops", body: "Coffee Origin/Name is required.", iconText: iconText)
            view.button?.isHidden = true
            
            // Show the message.
            SwiftMessages.show(view: view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFlavorWheelEdit" {
            let flavorWheelEditVC:FlavorWheelEditViewController = segue.destination as! FlavorWheelEditViewController
            flavorWheelEditVC.coffee = sender as! Coffee
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
    
    func isNil(_ any:Optional<Any>?) -> Bool {
        return any.unsafelyUnwrapped == nil
    }
}

