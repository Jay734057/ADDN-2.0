
//  BarChart.swift
//  ADDN 2.0
//
//  View for the bar chart
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
        
        titleLabel.text = title
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var dataPoints:[String]!
    var groupedValues:[[Double]]!
    var labels: [String]!
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        
        self.data = data
        
        
        
        drawGridBackgroundEnabled = true
        gridBackgroundColor = UIColor.darkGray
        chartDescription?.text = ""
        
        leftAxis.axisMinimum = 0
        rightAxis.axisMinimum = 0
        
        xAxis.valueFormatter = self
        xAxis.setLabelCount(dataPoints.count, force: false)
        xAxis.labelPosition = .bottom
        
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .bottom
        
        animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        addSubview(titleLabel)
        //
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: -24).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -12).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dataPoints[Int(value)]
    }

}
