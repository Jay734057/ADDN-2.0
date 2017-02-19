//
//  SingleSelectController.swift
//  ADDN 2.0
//
//  Created by Jay on 25/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class SingleSelectMenuController: SelectMenuController {
    
    var selectedIndex: Int?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //change the selectedIndex for the related item
        if let i = index {
            if let selected = selectedIndex {
                reportOptionController?.selectedAttributeIndexes[i] = [selected]
            } else {
                reportOptionController?.selectedAttributeIndexes[i] = []
            }
        }
    }
    
    
    //setup table cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        cell.textLabel?.text = items[indexPath.row]
        if selectedIndex != nil, indexPath.row == selectedIndex {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selectedIndex = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        selectedIndex = nil
    }

}
