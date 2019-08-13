//
//  CoffeeChartCell.swift
//  drip
//
//  Created by Grant Isom on 8/13/19.
//  Copyright © 2019 Grant Isom. All rights reserved.
//

import UIKit
import Charts

class CoffeeChartCell: UITableViewCell {
    var coffee: Coffee!
    var flavors = ["Sweet", "Sour/Tart", "Floral", "Spicy", "Salty", "Berry Fruit", "Citrus Fruit", "Stone Fruit", "Chocolate", "Caramel", "Smoky", "Bitter", "Savory", "Body", "Clean", "Linger/Finish"]
    var dataEntries: [RadarChartDataEntry]!
    var chartData: RadarChartData!
    let radarChartView = RadarChartView()
    
    convenience init(_ coffee: Coffee) {
        self.init()
        self.coffee = coffee
        setChartData()
    }
    
    func setChartData() {
        radarChartView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(radarChartView)
        radarChartView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        radarChartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        radarChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        radarChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        if let flavorProfile = coffee.flavorProfile {
            let jsonData = flavorProfile.data(using: .utf8)
            let flavorProfile = try! JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as! Dictionary<String, Float>
            
            dataEntries = []
            var usedFlavors: [String] = []
            for flavor in flavors {
                let value = flavorProfile[flavor]
                if value != 0 {
                    dataEntries.append(RadarChartDataEntry.init(value: Double(value!)))
                    usedFlavors.append(flavor)
                }
            }
            flavors = usedFlavors
            
            let coffeeData = RadarChartDataSet(entries: dataEntries, label: coffee.name)
            coffeeData.colors = ChartColorTemplates.pastel()
            coffeeData.drawFilledEnabled = true
            coffeeData.fillAlpha = 0.7
            coffeeData.lineWidth = 2
            coffeeData.drawHighlightCircleEnabled = true
            coffeeData.setDrawHighlightIndicators(false)
            
            chartData = RadarChartData(dataSets: [coffeeData])
            chartData.setValueFont(.systemFont(ofSize: 8, weight: .light))
            chartData.setDrawValues(false)
            chartData.setValueTextColor(.white)
            
            radarChartView.delegate = self
            radarChartView.chartDescription?.enabled = false
            radarChartView.webLineWidth = 0
            radarChartView.innerWebLineWidth = 0
            radarChartView.legend.enabled = false
            radarChartView.yAxis.axisMaximum = 4
            radarChartView.yAxis.axisMinimum = 0
            
            let xAxis = radarChartView.xAxis
            xAxis.labelFont = .systemFont(ofSize: 12, weight: .medium)
            xAxis.labelTextColor = UIColor.darkGray
            xAxis.xOffset = 0
            xAxis.yOffset = 0
            xAxis.valueFormatter = self
            radarChartView.xAxis.drawLabelsEnabled = true
            radarChartView.yAxis.drawLabelsEnabled = false
            
            radarChartView.data = chartData
        }
    }
}

extension CoffeeChartCell: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return flavors[Int(value) % flavors.count]
    }
}

extension CoffeeChartCell: ChartViewDelegate {
    
}
