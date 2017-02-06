//
//  OverviewController.swift
//  ADDN 2.0
//
//  Created by Jay on 05/02/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class OverviewController: UITableViewController {
    
    var localIds : [Int]?
    
    var patientDic : [Int:Patient]?
    var lastUpdatedDate : String?
    
    let cellId = "CellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reports", style: .plain, target: self, action: #selector(showReportOptionController))
    
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        fetchData()
    }
    
    func showReportOptionController() {
        let reportOptionController = ReportOptionController(style: .grouped)
        navigationController?.pushViewController(reportOptionController, animated: true)
    }
    
    func generateURLForPatientTable(local_id_id: [Int]) -> String {
        var urlForPatientTable = "http://localhost:3000/patient?order=local_id_id&select=local_id_id,diabetes_type_value&active=not.eq.false"
        
        if local_id_id.count > 0 {
            urlForPatientTable = urlForPatientTable + "&local_id_id=in."
            for id in local_id_id {
                urlForPatientTable = urlForPatientTable + id.description + ","
            }
            urlForPatientTable = urlForPatientTable.substring(to: urlForPatientTable.index(before: urlForPatientTable.endIndex))
        }
        return urlForPatientTable
    }
    
    func fetchData() {
        if let ids = localIds {
            APIservice.sharedInstance.fetchFromURLForPatient(url: self.generateURLForPatientTable(local_id_id: ids), completion: { (patients: [Patient]) in
                self.patientDic = [Int:Patient]()
                for patient in patients {
                    if let id = patient.local_id_id {
                        self.patientDic?[Int(id)] = patient
                    }
                }
                self.processData()
            })
        }
    }
    
    var numberOfActive = 0
    var numberOfType_1 = 0
    var numberOfType_2 = 0
    var numberOfOther = 0
    
    func processData(){
        if let keys = patientDic?.keys{
            for key in keys {
                if let type = patientDic?[key]?.diabetes_type_value {
                    numberOfActive += 1
                    if type == "TYPE_1" {
                        numberOfType_1 += 1
                    }else if type == "TYPE_2" {
                        numberOfType_2 += 1
                    }else {
                        numberOfOther += 1
                    }
                }
            }
        }
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            switch indexPath.row {
            case 1:
                cell.textLabel?.text = "Type 1"
                cell.detailTextLabel?.text = numberOfType_1.description
                break
            case 2:
                cell.textLabel?.text = "Type 2"
                cell.detailTextLabel?.text = numberOfType_2.description
                break
            case 3:
                cell.textLabel?.text = "Other"
                cell.detailTextLabel?.text = numberOfOther.description
                break
            default:
                cell.textLabel?.text = "Total number of Active"
                cell.detailTextLabel?.text = numberOfActive.description
            }
        }else if indexPath.section == 1{
            cell.textLabel?.text = "Total number of Inactive"
            if let total = localIds?.count {
                cell.detailTextLabel?.text = (total - numberOfActive).description
            }
        }else if indexPath.section == 2 {
            cell.textLabel?.text = "Total"
            if let total = localIds?.count {
                cell.detailTextLabel?.text = total.description
            }
        }else if indexPath.section == 3 {
            cell.textLabel?.text = "Last updated Date"
            if let date = lastUpdatedDate {
                cell.detailTextLabel?.text = date
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude + 20
        }
        return CGFloat.leastNormalMagnitude
    }
    
    
}
