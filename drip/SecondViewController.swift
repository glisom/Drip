//
//  SecondViewController.swift
//  drip
//
//  Created by Isom,Grant on 5/18/18.
//  Copyright © 2018 Grant Isom. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

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
        
        let realm = try! Realm()
        let coffees:Results<Coffee> = realm.objects(Coffee.self)
        let coffee = coffees.first
        let jsonData = coffee?.flavorProfile.data(using: .utf8)
        let flavorProfile = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as! Dictionary<String, Float>
        
        //let block: (Int) -> RadarChartDataEntry = { _ in return RadarChartDataEntry(value: flavorProfile?.values[$0])}
        var chartData:[RadarChartDataEntry] = []
        for value in (flavorProfile?.values)! {
            chartData.append(RadarChartDataEntry.init(value: Double(value)))
        }
        let set2 = RadarChartDataSet(values: chartData, label: coffee?.name)
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

