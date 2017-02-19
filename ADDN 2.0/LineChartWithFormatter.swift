//
//  LineChartWithFormatter.swift
//  ADDN 2.0
//
//  View for the line chart
//
//  Created by Jay on 29/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import Charts

class LineChartWithFormatter: LineChartView, IAxisValueFormatter{
    init(dataPoints: [String], values: [Double]) {
        super.init(frame: CGRect.zero)
        
        self.dataPoints = dataPoints
        self.values = values
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var dataPoints:[String]!
    var values:[Double]!
    
    func setupView(){
        var dataEntries = [ChartDataEntry]()
        
        for i in 0..<dataPoints.count {
            dataEntries.append(ChartDataEntry(x: Double(i), y: values[i]))
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Cost per Month")
        chartDataSet.axisDependency = .left
        chartDataSet.setColor(UIColor.red.withAlphaComponent(0.5))
        chartDataSet.setCircleColor(UIColor.red)
        chartDataSet.lineWidth = 2.0
        chartDataSet.circleRadius = 6.0
        chartDataSet.fillAlpha = 65/255.0
        chartDataSet.fillColor = UIColor.red
        chartDataSet.highlightColor = UIColor.white
        chartDataSet.drawCirclesEnabled = true
        
        
        let data = LineChartData()
        data.addDataSet(chartDataSet)
        data.setValueTextColor(UIColor.white)
        
        self.data = data
        
        drawGridBackgroundEnabled = true
        gridBackgroundColor = UIColor.darkGray
        
        chartDescription?.text = "Linechart Demo"
        chartDescription?.font = UIFont.systemFont(ofSize: 18)
        chartDescription?.textColor = UIColor.white
        
        let limitLine = ChartLimitLine(limit: 30.0, label: "Target")
        limitLine.valueTextColor = UIColor.white
        rightAxis.addLimitLine(limitLine)
        
        
        xAxis.valueFormatter = self
        xAxis.setLabelCount(dataPoints.count, force: false)
        
        animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dataPoints[Int(value)]
    }
}
