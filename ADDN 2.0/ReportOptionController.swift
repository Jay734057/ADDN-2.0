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
    
    //data for HbA1c switch
    var switchForHbA1c: UISwitch?
    var detailLabelForHbA1cSwitchButton: UILabel?
    var FlagForHbA1cTypes = false
    var HbA1cRangesForIFFC = Constants.PRESET_HbA1c_RANGES_FOR_IFFC
    var HbA1cRangesForNGSP = Constants.PRESET_HbA1c_RANGES_FOR_NGSP
    
    //switch button for other items
    var switchForContact: UISwitch?
    var switchAgeBreakDownByGender: UISwitch?
    var switchInsulinRegimenBreakDownByAge: UISwitch?
    //Flags for other switch buttons
    var FlagForConsentToBeContacted = false
    var FlagForAgeBreakDown = false
    var FlagForInsulinRegimenBreakDown = false
    
    //variables to store all set ranges and selected indexes for items
    var ranges = Constants.PRESET_RANGES
    var selectedAttributeIndexes = [[Int](),[Constants.PRESET_DIABETES_TYPE_INDEX],[Int]()]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "HbA1c"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 61, green: 91, blue: 151)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Generate", style: .plain, target: self, action: #selector(fetchDataForDetailedReport))
        
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
    
    //setup the option table cells
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
            cell.selectionStyle = .none
            //
            cell.titleLabelWidthAnchorConstraint?.isActive = true
            cell.titleLabelRightAnChorConstraint?.isActive = false
            cell.detailLabel.isHidden = false
            
            cell.titleLabel.text = Constants.SELECTABLE_ITEMS[indexPath.section][indexPath.row]
            cell.switchButton.setOn(FlagForHbA1cTypes, animated: true)
            if FlagForHbA1cTypes {
                cell.detailLabel.text = Constants.SELECTABLE_HbA1c_TYPES[1]
                ranges[indexPath.section] = HbA1cRangesForIFFC
            } else {
                cell.detailLabel.text = Constants.SELECTABLE_HbA1c_TYPES[0]
                ranges[indexPath.section] = HbA1cRangesForNGSP
            }
            switchForHbA1c = cell.switchButton
            detailLabelForHbA1cSwitchButton = cell.detailLabel
            cell.switchButton.addTarget(self, action: #selector(handleSwitchForHbA1cTypes), for: .valueChanged)
            return cell
        }
        
        if indexPath.section == 4{
            let cell = SwitchCell()
            cell.selectionStyle = .none
            //
            cell.titleLabelWidthAnchorConstraint?.isActive = false
            cell.titleLabelRightAnChorConstraint?.isActive = true
            cell.detailLabel.isHidden = true
            
            cell.titleLabel.text = Constants.SELECTABLE_ITEMS[indexPath.section][indexPath.row]
            
            switch indexPath.row {
            case 0:
                cell.switchButton.setOn(FlagForConsentToBeContacted, animated: true)
                switchForContact = cell.switchButton
                cell.switchButton.addTarget(self, action: #selector(handleSwitchForBeingContacted), for: .valueChanged)
                break
            case 1:
                cell.switchButton.setOn(FlagForAgeBreakDown, animated: true)
                switchAgeBreakDownByGender = cell.switchButton
                cell.switchButton.addTarget(self, action: #selector(handleSwitchForAgeBreakDown), for: .valueChanged)
                break
            default:
                cell.switchButton.setOn(FlagForInsulinRegimenBreakDown, animated: true)
                switchInsulinRegimenBreakDownByAge = cell.switchButton
                cell.switchButton.isEnabled = false
                cell.titleLabel.textColor = UIColor.lightGray
                cell.switchButton.addTarget(self, action: #selector(handleSwitchForInsulinRegimenBreakDown), for: .valueChanged)
            }
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
        if indexPath.section < 4 {
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
    }
    
    //get text for detailed labels in cells
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

    //switch the HbA1c Types
    func handleSwitchForHbA1cTypes(){
        if (switchForHbA1c?.isOn)! {
            FlagForHbA1cTypes = true
            detailLabelForHbA1cSwitchButton?.text = Constants.SELECTABLE_HbA1c_TYPES[1]
            ranges[ranges.count - 1] = HbA1cRangesForIFFC
        }else {
            FlagForHbA1cTypes = false
            detailLabelForHbA1cSwitchButton?.text = Constants.SELECTABLE_HbA1c_TYPES[0]
            ranges[ranges.count - 1] = HbA1cRangesForNGSP
        }
    }
    
    //switch for patients allowing contact
    func handleSwitchForBeingContacted() {
        if (switchForContact?.isOn)! {
            FlagForConsentToBeContacted = true
        }else {
            FlagForConsentToBeContacted = false
        }
    }
    
    //switch for generate age break down report
    func handleSwitchForAgeBreakDown() {
        if (switchAgeBreakDownByGender?.isOn)! {
            FlagForAgeBreakDown = true
        }else {
            FlagForAgeBreakDown = false
        }
    }
    
    //switch for generate insulin regimen break down report
    func handleSwitchForInsulinRegimenBreakDown() {
        if (switchInsulinRegimenBreakDownByAge?.isOn)! {
            FlagForInsulinRegimenBreakDown = true
        }else {
            FlagForInsulinRegimenBreakDown = false
        }
    }
}
