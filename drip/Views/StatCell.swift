//
//  StatCell.swift
//  drip
//
//  Created by Grant Isom on 8/14/19.
//  Copyright © 2019 Grant Isom. All rights reserved.
//

import UIKit
import RealmSwift
import Charts
import UICountingLabel
import Cosmos

class StatCell: UITableViewCell {
    var flavors = ["Sweet", "Sour/Tart", "Floral", "Spicy", "Salty", "Berry Fruit", "Citrus Fruit", "Stone Fruit", "Chocolate", "Caramel", "Smoky", "Bitter", "Savory", "Body", "Clean", "Linger/Finish"]

    convenience init(_ coffees: Results<Coffee>, _ statType: StatType) {
        self.init()
        isUserInteractionEnabled = false
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        let cardView = UIView()
        contentView.addSubview(cardView)
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 20.0
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -35).isActive = true
        cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: (frame.width * 1.5)).isActive = true
        
        
        let titleLabel = UILabel()
        cardView.addSubview(titleLabel)
        titleLabel.text = cellTitle(statType)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1).bold()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20).isActive = true
        
        switch statType {
        case .overall:
            showCoffeesThisWeek(titleLabel, cardView, coffees)
        case .flavorProfile:
            showOverallFlavorProfile(titleLabel, cardView, coffees)
        case .totalSpend:
            showTotalSpend(titleLabel, cardView, coffees)
        case .avgRating:
            showAvgRating(titleLabel, cardView, coffees)
        }
        
    }
    
    func showTotalSpend(_ titleLabel: UILabel, _ cardView: UIView, _ coffees: Results<Coffee>) {
        let totalSpendLabel = UICountingLabel()
        cardView.addSubview(totalSpendLabel)
        totalSpendLabel.translatesAutoresizingMaskIntoConstraints = false
        totalSpendLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        totalSpendLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20).isActive = true
        totalSpendLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20).isActive = true
        totalSpendLabel.heightAnchor.constraint(equalTo: totalSpendLabel.widthAnchor).isActive = true
        var totalCost = 0.0
        for coffee in coffees {
            totalCost += coffee.price
        }
        totalSpendLabel.count(from: 0.0, to: CGFloat(totalCost))
        totalSpendLabel.format = "$%.02f"
        totalSpendLabel.font = UIFont.systemFont(ofSize: 100, weight: .light)
        totalSpendLabel.textAlignment = .center
    }
    
    func showAvgRating(_ titleLabel: UILabel, _ cardView: UIView, _ coffees: Results<Coffee>) {
        let stars = CosmosView()
        cardView.addSubview(stars)
        stars.settings.starSize = 45
        stars.translatesAutoresizingMaskIntoConstraints = false
        stars.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        stars.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        var rating: Float = 0.0
        for coffee in coffees {
            rating += coffee.rating
        }
        let avgRating = rating/Float(coffees.count)
        stars.rating = Double(avgRating)
    }

    func showCoffeesThisWeek(_ titleLabel: UILabel, _ cardView: UIView, _ coffees: Results<Coffee>) {
        let chartView = BarChartView()
        chartView.delegate = self
        chartView.drawValueAboveBarEnabled = false
        cardView.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        chartView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20).isActive = true
        chartView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20).isActive = true
        chartView.heightAnchor.constraint(equalTo: chartView.widthAnchor).isActive = true
        
        var coffeesOnEachDay = [0,0,0,0,0,0,0]
        for coffee in coffees {
            if coffee.brewDate.isInThisWeek {
                let weekday = Calendar.current.component(.weekday, from: coffee.brewDate)
                coffeesOnEachDay[weekday - 1] += 1
            }
        }
        var dataEntries: [BarChartDataEntry] = []
        var showChart = false
        for (i, day) in coffeesOnEachDay.enumerated() {
            let entry = BarChartDataEntry(x: Double(i), y: Double(day))
            dataEntries.append(entry)
            if day > 0 {
                showChart = true
            }
        }
        if showChart {
            let chartDataSet = BarChartDataSet(entries: dataEntries, label: nil)
            chartDataSet.drawValuesEnabled = false
            let chartData = BarChartData(dataSet: chartDataSet)
            chartView.data = chartData
        }
        let yAxisFormatter = NumberFormatter()
        yAxisFormatter.minimumFractionDigits = 0
        yAxisFormatter.maximumFractionDigits = 0
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .systemFont(ofSize: 10)
        yAxis.axisMinLabels = 1
        yAxis.axisMaxLabels = 26
        yAxis.labelCount = coffeesOnEachDay.max() ?? 1
        yAxis.valueFormatter = DefaultAxisValueFormatter(formatter: yAxisFormatter)
        yAxis.labelPosition = .outsideChart
        yAxis.spaceTop = 0
        yAxis.axisMinimum = 0
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.valueFormatter = DayFormatter()
        xAxis.drawGridLinesEnabled = false
        
        chartView.rightAxis.enabled = false
        chartView.legend.form = .none
        chartView.noDataText = "No Coffess this week."
    }
    
    func showOverallFlavorProfile(_ titleLabel: UILabel, _ cardView: UIView, _ coffees: Results<Coffee>) {
        let radarChartView = RadarChartView()
        var dataEntries: [RadarChartDataEntry]!
        var chartData: RadarChartData!
        radarChartView.delegate = self
        radarChartView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(radarChartView)
        radarChartView.translatesAutoresizingMaskIntoConstraints = false
        radarChartView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        radarChartView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20).isActive = true
        radarChartView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20).isActive = true
        radarChartView.heightAnchor.constraint(equalTo: radarChartView.widthAnchor).isActive = true
        dataEntries = []
        var usedFlavors: [String] = []
        for coffee in coffees {
            if let flavorProfile = coffee.flavorProfile {
                let jsonData = flavorProfile.data(using: .utf8)
                let flavorProfile = try! JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as! Dictionary<String, Float>
                
                for flavor in flavors {
                    let value = flavorProfile[flavor]
                    if value != 0 {
                        dataEntries.append(RadarChartDataEntry.init(value: Double(value!)))
                        usedFlavors.append(flavor)
                    }
                }
                flavors = usedFlavors
            }
        }
        
        let coffeeData = RadarChartDataSet(entries: dataEntries, label: "Flavor Profile")
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
    
    func cellTitle(_ statType: StatType) -> String {
        switch statType {
        case .overall:
            return "Coffee this Week"
        case .flavorProfile:
            return "Your Flavor Profile"
        case .totalSpend:
            return "Total Spent"
        case .avgRating:
            return "Average Rating"
        }
    }
}

extension StatCell: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return flavors[Int(value) % flavors.count]
    }
}

extension StatCell: ChartViewDelegate {
    
}

enum StatType {
    case overall
    case flavorProfile
    case totalSpend
    case avgRating
}
