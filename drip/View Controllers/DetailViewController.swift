//
//  DetailViewController.swift
//  drip
//
//  Created by Isom,Grant on 5/18/18.
//  Copyright © 2018 Grant Isom. All rights reserved.
//

import UIKit
import Charts

class DetailViewController: UIViewController, ChartViewDelegate {
    var coffee:Coffee!
    
    var radarChartView: RadarChartView!
    var flavors = ["Sweet", "Sour/Tart", "Floral", "Spicy", "Salty", "Berry Fruit", "Citrus Fruit", "Stone Fruit", "Chocolate", "Caramel", "Smoky", "Bitter", "Savory", "Body", "Clean", "Linger/Finish"]
    var chartData: [RadarChartDataEntry]!
    
    @IBOutlet weak var coffeeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var chartView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let jsonData = coffee.flavorProfile.data(using: .utf8)
        let flavorProfile = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as! Dictionary<String, Float>
        chartData = []
        var usedFlavors: [String] = []
        for flavor in flavors {
            let value = flavorProfile![flavor]
            if value != 0 {
                chartData.append(RadarChartDataEntry.init(value: Double(value!)))
                usedFlavors.append(flavor)
            }
        }
        flavors = usedFlavors
        
        self.navigationItem.title = coffee.name
        
        chartView.layer.masksToBounds = false;
        chartView.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        chartView.layer.shadowRadius = 3
        chartView.layer.shadowColor = UIColor.lightGray.cgColor
        chartView.layer.shadowOpacity = 0.4
        chartView.layer.cornerRadius = 3
        let radius = chartView.layer.cornerRadius
        chartView.layer.shadowPath = UIBezierPath(roundedRect: chartView.bounds, cornerRadius: radius).cgPath
        
        setChartData()
    }
    
    func setChartData() {
        radarChartView = RadarChartView(frame: CGRect.init(x: 0, y: 0, width: chartView.frame.width, height: chartView.frame.height))
        chartView.addSubview(radarChartView)
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
        
        
        let set2 = RadarChartDataSet(values: chartData, label: coffee?.name)
        set2.colors = ChartColorTemplates.pastel()
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
    
extension DetailViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return flavors[Int(value) % flavors.count]
    }
}

