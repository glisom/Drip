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

class StatCell: UITableViewCell {

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
        for (i, day) in coffeesOnEachDay.enumerated() {
            let entry = BarChartDataEntry(x: Double(i), y: Double(day))
            dataEntries.append(entry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: nil)
        chartDataSet.drawValuesEnabled = false
        let chartData = BarChartData(dataSet: chartDataSet)
        chartView.data = chartData
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
    }

}

extension StatCell: ChartViewDelegate {
    
}

func cellTitle(_ statType: StatType) -> String {
    switch statType {
    case .overall:
        return "Coffee this Week"
    case .flavorProfile:
        return "Your Flavor Profile"
    }
}

enum StatType {
    case overall
    case flavorProfile
}
