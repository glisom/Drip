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
    let flavors = ["Sweet", "Sour/Tart", "Floral", "Spicy", "Salty", "Berry Fruit", "Citrus Fruit", "Stone Fruit", "Chocolate", "Caramel", "Smoky", "Bitter", "Savory", "Body", "Clean", "Linger/Finish"]
    
    @IBOutlet weak var coffeeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChartData()
        self.navigationItem.title = coffee.name
        coffeeImageView.image = UIImage.init(data: coffee.image)
        titleLabel.text = coffee.name
        subTitleLabel.text = coffee.roaster
        descriptionLabel.text = coffee.notes
        
    }
    
    func setChartData() {
        radarChartView = RadarChartView(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.width))
        //view.addSubview(radarChartView)
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
        
        let jsonData = coffee.flavorProfile.data(using: .utf8)
        let flavorProfile = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as! Dictionary<String, Float>
        
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
    
extension DetailViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return flavors[Int(value) % flavors.count]
    }
}

