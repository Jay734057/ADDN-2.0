//
//  MultiSelectController.swift
//  ADDN 2.0
//
//  Created by Jay on 23/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class MultiSelectMenuController: SelectMenuController {
    
    var selectedIndex = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //allow multiple selection
        tableView.allowsMultipleSelection = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //change the selected indexes array
        selectedIndex = selectedIndex.sorted()
        if let i = index {
            reportOptionController?.selectedAttributeIndexes[i] = selectedIndex
        }
    }
    
    //setup the table cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        cell.textLabel?.text = items[indexPath.row]
        if selectedIndex.index(of: indexPath.row) != nil {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selectedIndex.append(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        if let index = selectedIndex.index(of: indexPath.row){
            selectedIndex.remove(at: index)
        }
    }
}



