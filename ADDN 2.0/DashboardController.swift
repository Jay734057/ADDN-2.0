//
//  DashboardController.swift
//  ADDN 2.0
//
//  Dashboard for all available hospital data
//
//  Created by Jay on 05/02/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class DashboardController: UITableViewController {
    
    let cellId = "CellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Dashboard"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 61, green: 91, blue: 151)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.register(MenuCell.self , forCellReuseIdentifier: cellId)
        
        fetchDataFromLocalIdTable()
        
    }
    
    var centersWithIdsOfPatientsAndUpdatedDates : [String:([Int],String)]?
    
    func fetchDataFromLocalIdTable() {
        //setup request url
        let url = Constants.URL_PREFIX + "localid?select=id,centre,date_of_export&date_of_last_visit=not.is.null"
        
        //retrieve data from localid table
        APIservice.sharedInstance.fetchFromURLForLocalId(url: url) { (localIds: [LocalID]) in
            self.centersWithIdsOfPatientsAndUpdatedDates = [String:([Int],String)]()
            for localId in localIds {
                //analyze retrieved data
                if let center = localId.centre, let id = localId.id, let date = localId.date_of_export  {
                    //grouped patient ids by centres
                    if self.centersWithIdsOfPatientsAndUpdatedDates?[center] == nil {
                        self.centersWithIdsOfPatientsAndUpdatedDates?[center] = ([Int(id)],date)
                    }else {
                        self.centersWithIdsOfPatientsAndUpdatedDates?[center]?.0.append(Int(id))
                        //get the last updated date of the center data
                        if let lastUpdated = self.centersWithIdsOfPatientsAndUpdatedDates?[center]?.1, lastUpdated < date {
                            self.centersWithIdsOfPatientsAndUpdatedDates?[center]?.1 = date
                        }
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    //setup the dashboard table menu
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let centers = centersWithIdsOfPatientsAndUpdatedDates?.keys {
            return centers.count
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuCell
        cell.profileImageView.image = UIImage(named: "h\(indexPath.row)")
        cell.accessoryType = .disclosureIndicator
        
        if let centers = centersWithIdsOfPatientsAndUpdatedDates?.keys {
            let centersArray = [String](centers)
            cell.menuTextLabel.text = centersArray[indexPath.row]
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let overviewController = OverviewController(style: .grouped)
        let text = (tableView.cellForRow(at: indexPath) as! MenuCell).menuTextLabel.text

        overviewController.navigationItem.title = text
        overviewController.localIds = centersWithIdsOfPatientsAndUpdatedDates?[text!]?.0
        overviewController.lastUpdatedDate = centersWithIdsOfPatientsAndUpdatedDates?[text!]?.1
        
        navigationController?.pushViewController(overviewController, animated: true)

    }
    
}










