//
//  PieChart.swift
//  ADDN 2.0
//
//  Created by Jay on 29/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import Charts

class PieChart: PieChartView {
    init(dataPoints: [String], values: [Double], title: String) {
        super.init(frame: CGRect.zero)
        
        self.dataPoints = dataPoints
        self.values = values
        
        
        chartDescription?.text = title
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var dataPoints:[String]!
    var values:[Double]!
    
    func setupView(){
        noDataText = "You need to provide data for the chart"
        noDataFont = UIFont.systemFont(ofSize: 18)
        
        var dataEntries = [PieChartDataEntry]()
        var colors: [UIColor] = []
        
        if dataPoints.count < 6 {
            for i in 0..<dataPoints.count {
                dataEntries.append(PieChartDataEntry(value: values[i], label: dataPoints[i]))
            }
            colors = ChartColorTemplates.colorful()
        }else {
            for i in 0..<dataPoints.count {
                dataEntries.append(PieChartDataEntry(value: values[i], label: dataPoints[i]))
                
                let red = Double(arc4random_uniform(256))
                let green = Double(arc4random_uniform(256))
                let blue = Double(arc4random_uniform(256))
                let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                colors.append(color)
            }
        }
        
        let dataSet = PieChartDataSet(values: dataEntries, label: "")
        dataSet.colors = colors
        dataSet.valueTextColor = UIColor.black
        
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
//        formatter.numberStyle = 
//        formatter.maximumFractionDigits = 1
//        formatter.multiplier = 1.0
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)

        let data = PieChartData()
        data.addDataSet(dataSet)
        
        self.data = data
        
        drawEntryLabelsEnabled = false
//        drawHoleEnabled = false
        
        chartDescription?.font = UIFont.systemFont(ofSize: 12)
        
        animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
}
