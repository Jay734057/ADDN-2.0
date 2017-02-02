//
//  BarChartController.swift
//  ADDN 2.0
//
//  Created by Jay on 22/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import Charts

class BarChartController: UIViewController, IAxisValueFormatter  {
    
    var navTitle: String? {
        didSet {
            navigationItem.title = navTitle
        }
    }
    
    var dataPoints:[String]!
    var values:[Double]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveChartToCameraRoll))
        
        tabBarController?.tabBar.isHidden = true
        
        let backBarButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(navigationController?.popViewController(animated:)))
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButton
        
        setupView()
        
        dataPoints = ["Male","Female"]
        values = [212,208]
        
        setChart(dataPoints: dataPoints, values: values)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    func saveChartToCameraRoll() {
        
        if let image = barChartView.getChartImage(transparent: false) {
            let alterController = UIAlertController(title: "Save Chart", message: "Do you want to save the chart to Camera Roll?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
                alterController.dismiss(animated: true, completion: nil)
            }
            let saveAction = UIAlertAction(title: "Save", style: .cancel) { (action) in
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            
            alterController.addAction(cancelAction)
            alterController.addAction(saveAction)
            
            self.present(alterController, animated: true, completion: nil)
        }
    }
    
    
    
    func setupView() {
        //        view.addSubview(barChartLabel)
        //        //xywh
        //        barChartLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //        barChartLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 18).isActive = true
        //        barChartLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        //        barChartLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        view.addSubview(barChartView)
        //xywh
        barChartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        barChartView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        barChartView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        barChartView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
    }
    
    let barChartLabel: UILabel = {
        let label = UILabel()
        label.text = "Barchart Demo"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let barChartView: BarChartView = {
        let bcv = BarChartView()
        //        bcv.backgroundColor = UIColor.blue
        bcv.noDataText = "You need to provide data for the chart"
        bcv.noDataFont = UIFont.systemFont(ofSize: 18)
        bcv.translatesAutoresizingMaskIntoConstraints = false
        return bcv
    }()
    
    func setChart(dataPoints: [String], values: [Double]){
        var dataentries = [BarChartDataEntry]()
        for i in 0..<dataPoints.count {
            dataentries.append(BarChartDataEntry(x: Double(i), y: values[i]))
        }
        
        let chartDataSet = BarChartDataSet(values: dataentries, label: "Cost per Month")
        chartDataSet.axisDependency = .left
        chartDataSet.setColor(UIColor.red.withAlphaComponent(0.5))
        chartDataSet.highlightColor = UIColor.white
        
        let data = BarChartData()
        data.addDataSet(chartDataSet)
        data.setValueTextColor(UIColor.white)
        data.barWidth = 0.5
        
        
        barChartView.data = data
        
        barChartView.drawGridBackgroundEnabled = true
        barChartView.gridBackgroundColor = UIColor.darkGray
        
        barChartView.chartDescription?.text = "Barchart Demo"
        barChartView.chartDescription?.font = UIFont.systemFont(ofSize: 18)
        barChartView.chartDescription?.textColor = UIColor.white
        
        let limitLine = ChartLimitLine(limit: 30.0, label: "Target")
        limitLine.valueTextColor = UIColor.white
        barChartView.rightAxis.addLimitLine(limitLine)
        
        barChartView.xAxis.valueFormatter = self
        barChartView.xAxis.setLabelCount(2, force: false)
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dataPoints[Int(value)]
    }
}

