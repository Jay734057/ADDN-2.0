//
//  DashboardController.swift
//  ADDN 2.0
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
        
        fetchData()
        
    }
    
    
    var centersWithIdOfPatientsAndUpdatedDate : [String:([Int],String)]?
    
    func fetchData() {
        let url = Constants.URL_PREFIX + "localid?select=id,centre,date_of_export&date_of_last_visit=not.is.null"
        
        APIservice.sharedInstance.fetchFromURLForLocalId(url: url) { (localIds: [LocalID]) in
            self.centersWithIdOfPatientsAndUpdatedDate = [String:([Int],String)]()
            for localId in localIds {
                if let center = localId.centre, let id = localId.id, let date = localId.date_of_export  {
                    if self.centersWithIdOfPatientsAndUpdatedDate?[center] == nil {
                        self.centersWithIdOfPatientsAndUpdatedDate?[center] = ([Int(id)],date)
                    }else {
                        self.centersWithIdOfPatientsAndUpdatedDate?[center]?.0.append(Int(id))
                        if let lastUpdated = self.centersWithIdOfPatientsAndUpdatedDate?[center]?.1, lastUpdated < date {
                            self.centersWithIdOfPatientsAndUpdatedDate?[center]?.1 = date
                        }
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let centers = centersWithIdOfPatientsAndUpdatedDate?.keys {
            return centers.count
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuCell
        cell.profileImageView.image = UIImage(named: "h\(indexPath.row)")
        cell.accessoryType = .disclosureIndicator
        
        if let centers = centersWithIdOfPatientsAndUpdatedDate?.keys {
            let centersArray = [String](centers)
            cell.menuTextLabel.text = centersArray[indexPath.row]
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let overviewController = OverviewController(style: .grouped)
        let text = (tableView.cellForRow(at: indexPath) as! MenuCell).menuTextLabel.text

        overviewController.navigationItem.title = text
        overviewController.localIds = centersWithIdOfPatientsAndUpdatedDate?[text!]?.0
        overviewController.lastUpdatedDate = centersWithIdOfPatientsAndUpdatedDate?[text!]?.1
        
        navigationController?.pushViewController(overviewController, animated: true)

    }
    
}










