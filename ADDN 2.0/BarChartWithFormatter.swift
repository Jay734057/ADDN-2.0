
//  BarChart.swift
//  ADDN 2.0
//
//  Created by Jay on 29/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import Charts

class BarChartWithFormatter: BarChartView,IAxisValueFormatter {
    init(dataPoints: [String], groupedValues: [[Double]],labels:[String],title: String) {
        super.init(frame: CGRect.zero)
        
        self.dataPoints = dataPoints
        self.groupedValues = groupedValues
        self.labels = labels
        
        chartDescription?.text = title
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var dataPoints:[String]!
    var groupedValues:[[Double]]!
    var labels: [String]!
    
    let colors = [UIColor.red,UIColor.green,UIColor.blue,UIColor.orange,UIColor.cyan,UIColor.purple,UIColor.brown,UIColor.white,UIColor.magenta,UIColor.lightGray]
    
    func setupView(){
        noDataText = "You need to provide data for the chart"
        noDataFont = UIFont.systemFont(ofSize: 18)
        
        let data = BarChartData()
        
        for i in 0..<groupedValues.count{
            let values = groupedValues[i]
            var dataentries = [BarChartDataEntry]()
            for i in 0..<dataPoints.count {
                dataentries.append(BarChartDataEntry(x: Double(i), y: values[i]))
            }
            let chartDataSet = BarChartDataSet(values: dataentries, label: labels[i])
            chartDataSet.axisDependency = .left
            chartDataSet.setColor(colors[i].withAlphaComponent(0.5))
            chartDataSet.highlightColor = UIColor.white
            
            data.addDataSet(chartDataSet)
        }
        
        
        
        data.setValueTextColor(UIColor.white)
        
        data.barWidth = 0.4
        if data.dataSets.count > 1 {
            data.barWidth = 0.8 / Double(data.dataSets.count)
            data.groupBars(fromX: -0.5, groupSpace: 0.2, barSpace: 0)
        }
        
        
//        print(data.barWidth)
//        print(data.groupWidth(groupSpace: 0.08, barSpace: 0))
        
        
        
        self.data = data
        
        
        
        drawGridBackgroundEnabled = true
        gridBackgroundColor = UIColor.darkGray
        
        chartDescription?.font = UIFont.systemFont(ofSize: 18)
        chartDescription?.textColor = UIColor.white
        
//        let limitLine = ChartLimitLine(limit: 30.0, label: "Target")
//        limitLine.valueTextColor = UIColor.white
//        rightAxis.addLimitLine(limitLine)
        
        leftAxis.axisMinimum = 0
        rightAxis.axisMinimum = 0
        
        xAxis.valueFormatter = self
        xAxis.setLabelCount(dataPoints.count, force: false)
//        xAxis.avoidFirstLastClippingEnabled = true
        
        animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dataPoints[Int(value)]
    }
}
