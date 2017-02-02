//
//  ReportOptionExtensionForMenu.swift
//  ADDN 2.0
//
//  Created by Jay on 26/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

extension ReportOptionController {
    func showMultiSelectController(indexPath: IndexPath){
        let multiSelectController = MultiSelectMenuController()
        
        multiSelectController.items = Constants.SELECTABLE_ATTRIBUTES[indexPath.section]
        multiSelectController.selectedIndex = selectedAttributeIndexes[indexPath.section]
        
        multiSelectController.index = indexPath.section
        multiSelectController.reportOptionController = self
        
        multiSelectController.navigationItem.title = Constants.SELECTABLE_ITEMS[indexPath.section][indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(multiSelectController, animated: true)
    }
    
    func showSingleSelectController(indexPath: IndexPath){
        let singleSelectController = SingleSelectMenuController()
        
        singleSelectController.items = Constants.SELECTABLE_ATTRIBUTES[indexPath.section]
        if selectedAttributeIndexes[indexPath.section] != [] {
            singleSelectController.selectedIndex = selectedAttributeIndexes[indexPath.section][0]
        }
        singleSelectController.index = indexPath.section
        singleSelectController.reportOptionController = self
        
        singleSelectController.navigationItem.title = Constants.SELECTABLE_ITEMS[indexPath.section][indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(singleSelectController, animated: true)
    }
    
    func showRangeOptionsController(indexPath: IndexPath){
        let rangeOptionController = RangeMenuController()
        
        rangeOptionController.numberOfRanges = ranges[indexPath.section].count
        rangeOptionController.ranges = ranges[indexPath.section]
        
        rangeOptionController.index = indexPath.section
        rangeOptionController.reportOptionController = self
        
        rangeOptionController.navigationItem.title = Constants.SELECTABLE_ITEMS[indexPath.section][indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(rangeOptionController, animated: true)
    }

}
