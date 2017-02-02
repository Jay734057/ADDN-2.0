//
//  PieChartController.swift
//  ADDN 2.0
//
//  Created by Jay on 22/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import Charts

class PieChartController: UIViewController {
    
    var navTitle: String? {
        didSet {
            navigationItem.title = navTitle
        }
    }
    
    var dataPoints = [String]()
    var values = [Double]()
    
    lazy var pieChartView: PieChartView = {
        let pcv = PieChartView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
        pcv.noDataText = "You need to provide data for the chart"
        pcv.noDataFont = UIFont.systemFont(ofSize: 18)
        return pcv
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
        
//        dataPoints = ["Jan" , "Feb", "Mar", "Apr", "May", "Jun"]
//        values = [20.0,50.0,30.0,24.5,7.38, 61.2]
        
        setChart(dataPoints: dataPoints, values: values)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pieChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
        
    }
    func setupView() {
        view.addSubview(pieChartView)
    }
    
    func setChart(dataPoints: [String], values: [Double]){
        
        var dataEntries = [PieChartDataEntry]()
        var colors: [UIColor] = []
        
        for i in 0..<dataPoints.count {
            dataEntries.append(PieChartDataEntry(value: values[i], label: dataPoints[i]))
            
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        
        let dataSet = PieChartDataSet(values: dataEntries, label: "")
        dataSet.colors = colors
        
        let data = PieChartData()
        data.addDataSet(dataSet)
        
        pieChartView.data = data
        
        //        pieChartView.drawHoleEnabled = false
        
        pieChartView.chartDescription?.text = "Piechart Demo"
        pieChartView.chartDescription?.font = UIFont.systemFont(ofSize: 18)
        
        
    }
    
    
    
}





//        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
//        paragraphStyle.lineBreakMode = .byTruncatingTail
//        paragraphStyle.alignment = .center
//        let centerText: NSMutableAttributedString = NSMutableAttributedString(string: "Charts\nby Jay")
//        centerText.setAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 15.0)!, NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, centerText.length))
//
//        pieChartView.centerAttributedText = centerText


