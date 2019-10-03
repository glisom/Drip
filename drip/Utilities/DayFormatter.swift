//
//  DayFormatter.swift
//  drip
//
//  Created by Grant Isom on 8/14/19.
//  Copyright © 2019 Grant Isom. All rights reserved.
//

import Foundation
import Charts

public class DayFormatter: NSObject, IAxisValueFormatter {
    private let days = ["Sun", "Mon", "Tues", "Wed", "Thur", "Fri", "Sat"]
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return days[Int(value)]
    }
}
