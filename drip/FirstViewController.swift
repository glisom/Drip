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

class FirstViewController: FormViewController {
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("General Info")
            <<< TextRow(){ row in
                row.title = "Coffee Origin/Name"
            }
            <<< TextRow(){ row in
                row.title = "Roaster"
            }
            <<< TextRow(){ row in
                row.title = "Producer"
            }
            <<< DateRow(){ row in
                row.title = "Roast Date"
                row.value = Date()
            }
            <<< DateRow(){ row in
                row.title = "Brew Date"
                row.value = Date()
            }
            <<< TextRow(){ row in
                row.title = "Beverage"
            }
            <<< DecimalRow(){ row in
                row.title = "Price"
                row.useFormatterDuringInput = true
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                row.formatter = formatter
            }
            <<< PushRow<String>() {
                $0.title = "Brew Method"
                $0.options = ["Cupping", "Drip", "Espresso", "Pour Over", "Press", "Siphon", "Other"]
                $0.selectorTitle = "Choose an Brew Method!"
                }.onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
            }
            <<< TextRow(){ row in
                row.title = "Flavor Wheel"
            }
            <<< SliderRow(){ row in
                row.title = "Rating"
                row.maximumValue = 5
                row.minimumValue = 0
                row.steps = 5
                row.value = 0
            }
            <<< ImageRow() { row in
                row.title = "Image of coffee or bag."
            }
            +++ Section("Notes")
            <<< TextAreaRow(){ row in
            }
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        // If valid
        
        performSegue(withIdentifier: "showFlavorWheelEdit", sender: self)
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

