//
//  SecondViewController.swift
//  drip
//
//  Created by Isom,Grant on 5/18/18.
//  Copyright © 2018 Grant Isom. All rights reserved.
//

import UIKit
import Charts

class SecondViewController: UIViewController, ChartViewDelegate {
    
    var radarChartView: RadarChartView!
    let flavors = ["Sweet", "Sour/Tart", "Floral", "Spicy", "Salty", "Berry Fruit", "Citrus Fruit", "Stone Fruit", "Chocolate", "Caramel", "Smoky", "Bitter", "Savory", "Body", "Clean", "Linger/Finish"]

    override func viewDidLoad() {
        super.viewDidLoad()
        radarChartView = RadarChartView(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.width))
        view.addSubview(radarChartView)
        radarChartView.delegate = self
        radarChartView.chartDescription?.enabled = false
        radarChartView.webLineWidth = 1
        radarChartView.innerWebLineWidth = 1
        
        let xAxis = radarChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.valueFormatter = self
        xAxis.labelTextColor = .black
        radarChartView.xAxis.drawLabelsEnabled = true
        
        setChartData()
        
    }
    func setChartData() {
        let mult: UInt32 = 10
        let min: UInt32 = 1
        let cnt = 16
        
        let block: (Int) -> RadarChartDataEntry = { _ in return RadarChartDataEntry(value: Double(arc4random_uniform(mult) + min))}
        let entries2 = (0..<cnt).map(block)
        
        let set2 = RadarChartDataSet(values: entries2, label: "Example Coffee")
        set2.colors = ChartColorTemplates.colorful()
        set2.drawFilledEnabled = true
        set2.fillAlpha = 0.7
        set2.lineWidth = 2
        set2.drawHighlightCircleEnabled = true
        set2.setDrawHighlightIndicators(false)
        
        let data = RadarChartData(dataSets: [set2])
        data.setValueFont(.systemFont(ofSize: 8, weight: .light))
        data.setDrawValues(false)
        data.setValueTextColor(.white)
        
        radarChartView.data = data
    }
}
    
extension SecondViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return flavors[Int(value) % flavors.count]
    }
}

