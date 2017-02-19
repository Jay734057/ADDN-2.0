//
//  ReportPageViewController.swift
//  ADDN 2.0
//
//  Controller for showing the whole detailed report
//
//  Created by Jay on 11/02/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class ReportPageViewController: UIPageViewController,UIPageViewControllerDataSource {
    
    var navTitle: String? {
        didSet {
            navigationItem.title = navTitle
        }
    }
    
    var reports: [UIViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        self.dataSource = self
        
        if let firstViewController = reports?.first {
            setViewControllers([firstViewController], direction: .forward, animated: true,completion: nil)
        }
    }
    
    //set up the swipe actions for the report page controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = reports?.index(of: viewController){
            let nextIndex = index + 1
            if nextIndex >= (reports?.count)! {
                return reports?.first
            }
            return reports?[nextIndex]
        }else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = reports?.index(of: viewController){
            let previousIndex = index - 1
            if previousIndex < 0 {
               return reports?.last
            }
            return reports?[previousIndex]
        }else {
            return nil
        }
    }
    
    
}
