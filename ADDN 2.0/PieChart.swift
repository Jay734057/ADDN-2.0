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
        
        titleLabel.text = title
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var dataPoints:[String]!
    var values:[Double]!
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupView(){
        noDataText = "You need to provide data for the chart"
        noDataFont = UIFont.systemFont(ofSize: 18)
        
        var dataEntries = [PieChartDataEntry]()
        var colors: [UIColor] = []
        
        for i in 0..<dataPoints.count {
            dataEntries.append(PieChartDataEntry(value: values[i], label: dataPoints[i]))
        }
        
        if dataPoints.count < 6 {
            colors = ChartColorTemplates.colorful()
        }else {
            colors = ChartColorTemplates.colorful() + ChartColorTemplates.joyful()
        }
        
        let dataSet = PieChartDataSet(values: dataEntries, label: "")
        dataSet.colors = colors
        dataSet.valueTextColor = UIColor.black
        
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)

        let data = PieChartData()
        data.addDataSet(dataSet)
        
        self.data = data
        
        drawEntryLabelsEnabled = false
        
        chartDescription?.text = ""
        
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .center
        legend.orientation = .vertical
        
        animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
        
        addSubview(titleLabel)
        //
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: -16).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -12).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

}
