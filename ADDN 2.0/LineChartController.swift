//
//  LineChartController.swift
//  ADDN 2.0
//
//  Created by Jay on 22/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import Charts

class LineChartController: UIViewController, ChartViewDelegate, IAxisValueFormatter {
    
    var navTitle: String? {
        didSet {
            navigationItem.title = navTitle
        }
    }
    
    var dataPoints:[String]!
    var values:[Double]!
    
    lazy var lineChartView: LineChartView
        = {
            let lcv = LineChartView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
            lcv.noDataText = "You need to provide data for the chart"
            lcv.noDataFont = UIFont.systemFont(ofSize: 18)
            return lcv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        tabBarController?.tabBar.isHidden = true
        
        let backBarButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(navigationController?.popViewController(animated:)))
        self.navigationController?.navigationBar.topItem?.backBarButtonItem=backBarButton
        
        setupView()
        
        dataPoints = ["Jan" , "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        values = [20.0,50.0,0.0,30.0,24.5,7.38, 61.2, 48.7, 42.55, 39.8, 46.0, 43.5]
        
        setChart(dataPoints: dataPoints, values: values)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
    }
    func setupView() {
        view.addSubview(lineChartView)
    }
    
    func setChart(dataPoints: [String], values: [Double]){
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
        
        lineChartView.data = data
        
        lineChartView.drawGridBackgroundEnabled = true
        lineChartView.gridBackgroundColor = UIColor.darkGray
        
        lineChartView.chartDescription?.text = "Linechart Demo"
        lineChartView.chartDescription?.font = UIFont.systemFont(ofSize: 18)
        lineChartView.chartDescription?.textColor = UIColor.white
        
        let limitLine = ChartLimitLine(limit: 30.0, label: "Target")
        limitLine.valueTextColor = UIColor.white
        lineChartView.rightAxis.addLimitLine(limitLine)
        
        
        lineChartView.xAxis.valueFormatter = self
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        //        print(value)
        return dataPoints[Int(value)]
    }
}

