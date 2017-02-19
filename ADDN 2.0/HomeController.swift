//
//  HomeController.swift
//  ADDN 2.0
//
//  Home controller for the application
//
//  Created by Jay on 04/02/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class HomeController: UITableViewController {
    //all items in home controller
    let menu = ["Dashboard","Diabetes Type","Insulin Regimen","HbA1c","BMI SDS","Severe Hypo & DKA","Completeness & Audit"]
    
    let cellId = "CellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 61, green: 91, blue: 151)
        
        tableView.register(MenuCell.self , forCellReuseIdentifier: cellId)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    //setup table cells
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuCell
        cell.menuTextLabel.text = menu[indexPath.row]
        cell.profileImageView.image = UIImage(named: menu[indexPath.row])
        
        cell.accessoryType = .disclosureIndicator
        
        //set invalid items with lightgray color text
        switch indexPath.row {
        case 0:
            cell.selectionStyle = .gray
        case 3:
            cell.selectionStyle = .gray
        default:
            cell.selectionStyle = .none
            cell.menuTextLabel.textColor = UIColor.lightGray
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let dashboardController = DashboardController()
            navigationController?.pushViewController(dashboardController, animated: true)
            break
        case 3:
            let reportOptionController = ReportOptionController(style: .grouped)
            navigationController?.pushViewController(reportOptionController, animated: true)
            break
        default:
            break
        }
    }
    
}
