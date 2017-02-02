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
    
    var views: [UIView]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
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
    
    func setupView() {
        view.addSubview(scrollView)
        //xywh
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        if let charts = views {
            scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: CGFloat(charts.count * 250 + 32))
            
            for i in 0..<charts.count {
                
                charts[i].translatesAutoresizingMaskIntoConstraints = false
                
                scrollView.addSubview(charts[i])
                //xywh
                charts[i].centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
                charts[i].topAnchor.constraint(equalTo: scrollView.topAnchor, constant: CGFloat(i*250))   .isActive = true
                charts[i].widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9).isActive = true
                charts[i].heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.6).isActive = true
            }
        }
    }

}
