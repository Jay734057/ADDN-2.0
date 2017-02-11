//
//  ReportController.swift
//  ADDN 2.0
//
//  Created by Jay on 26/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import Charts

class ReportController: UIViewController {
    
    var navTitle: String? {
        didSet {
            navigationItem.title = navTitle
        }
    }
    
    var reportTitle: String? {
        didSet {
            reportTitleLabel.text = reportTitle
        }
    }
    
    var views: [UIView]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem=backBarButton
        
        setupView()
        
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.white
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let reportTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupView() {
        
        view.addSubview(scrollView)
        //xywh
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        if let charts = views {
            scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: CGFloat(Double((views?.count)!) * Double(view.frame.width) * 0.8))
            
            scrollView.addSubview(reportTitleLabel)
            //
            reportTitleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            reportTitleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
            reportTitleLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -36).isActive = true
            reportTitleLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            var topAnchor = reportTitleLabel.bottomAnchor
            
            for i in 0..<charts.count {
                
                charts[i].translatesAutoresizingMaskIntoConstraints = false
                
                scrollView.addSubview(charts[i])
                //xywh
                
                charts[i].centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
                if i == 0 {
                    charts[i].topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
                }else {
                    charts[i].topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
                }
                
                
                var multiplierForWidth:CGFloat = 0.0
                var multiplierForHeight:CGFloat = 0.0
                if type(of: charts[i]).description() == "ADDN_2_0.Tabular" {
                    multiplierForWidth = 0.98
                    multiplierForHeight = 0.8
                }else {
                    multiplierForWidth = 0.98
                    multiplierForHeight = 0.6
                }
                
                charts[i].widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: multiplierForWidth).isActive = true
                charts[i].heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: multiplierForHeight).isActive = true
                
                topAnchor = charts[i].bottomAnchor
                
            }
        }
    }

}
