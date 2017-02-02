//
//  HomeController.swift
//  ADDN 2.0
//
//  Created by Jay on 22/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class ReportOptionController: UITableViewController {
    
    
    let CellId = "MultiSelectCellId"
    
    let switchCellId = "SwitchCellId"
    
    var switchButton: UISwitch?
    var detailLabel: UILabel?
    
    var FlagForHbA1cTypes: Bool = false
    
    var HbA1cRangesForIFFC = Constants.PRESET_HbA1c_RANGES_FOR_IFFC
    
    var HbA1cRangesForNGSP = Constants.PRESET_HbA1c_RANGES_FOR_NGSP
    
    var ranges = Constants.PRESET_RANGES
    
    var selectedAttributeIndexes = [[Int](),[Constants.PRESET_DIABETES_TYPE_INDEX],[Int]()]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Report Options"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 61, green: 91, blue: 151)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Generate", style: .plain, target: self, action: #selector(fetchData))
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellId)
        
        tableView.register(SwitchCell.self, forCellReuseIdentifier: switchCellId)
        
        tableView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func dismissKeyboard() {
        tableView.endEditing(true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.SELECTABLE_ITEMS.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.SELECTABLE_ITEMS[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set up cell with switch
        if indexPath.section == 3 && indexPath.row == 0 {
            let cell = SwitchCell()
            cell.titleLabel.text = Constants.SELECTABLE_ITEMS[indexPath.section][indexPath.row]
            cell.switchButton.setOn(FlagForHbA1cTypes, animated: true)
            if FlagForHbA1cTypes {
                cell.detailLabel.text = Constants.SELECTABLE_HbA1c_TYPES[1]
                ranges[indexPath.section] = HbA1cRangesForIFFC
            } else {
                cell.detailLabel.text = Constants.SELECTABLE_HbA1c_TYPES[0]
                ranges[indexPath.section] = HbA1cRangesForNGSP
            }
            switchButton = cell.switchButton
            detailLabel = cell.detailLabel
            cell.switchButton.addTarget(self, action: #selector(handleSwitch), for: .valueChanged)
            return cell
        }
        
        //set up other cells
        let cell = UITableViewCell(style: .value1, reuseIdentifier: CellId)
        cell.textLabel?.text = Constants.SELECTABLE_ITEMS[indexPath.section][indexPath.row]
        if indexPath.row == 0 {
            cell.detailTextLabel?.text = getDetailText(items: Constants.SELECTABLE_ATTRIBUTES[indexPath.section], selectedIndex: selectedAttributeIndexes[indexPath.section])
        }
        cell.detailTextLabel?.textColor = UIColor.lightGray
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if indexPath.section == 1 {
                showSingleSelectController(indexPath: indexPath)
            }else if indexPath.section < 3{
                showMultiSelectController(indexPath: indexPath)
            }
        }else {
            showRangeOptionsController(indexPath: indexPath)
        }
    }
    
    func getDetailText(items: [String], selectedIndex: [Int]) -> String {
        if selectedIndex.count == 0 {
            return "Not set"
        }
        if items.count == selectedIndex.count {
            return "All"
        }
        var text = ""
        for i in selectedIndex {
            text += items[i] + ", "
        }
        text = text.substring(to: text.index(text.endIndex, offsetBy: -2))
        return text
    }

    func handleSwitch(){
        if (switchButton?.isOn)! {
            FlagForHbA1cTypes = true
            detailLabel?.text = Constants.SELECTABLE_HbA1c_TYPES[1]
            ranges[ranges.count - 1] = HbA1cRangesForIFFC
        }else {
            FlagForHbA1cTypes = false
            detailLabel?.text = Constants.SELECTABLE_HbA1c_TYPES[0]
            ranges[ranges.count - 1] = HbA1cRangesForNGSP
        }
    }
}
