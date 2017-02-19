//
//  RangeMenuController.swift
//  ADDN 2.0
//
//  Menu for range setting items
//
//  Created by Jay on 23/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class RangeMenuController: UITableViewController {
    
    var index:Int?
    
    var numberOfRanges = 0
    
    var ranges = [(Double,Double)]()
    
    let cellId = "CellId"
    
    var reportOptionController: ReportOptionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButton()
        
        tableView.allowsMultipleSelection = true
        
        tableView.register(RangeOptionCell.self, forCellReuseIdentifier: cellId)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        tableView.keyboardDismissMode = .onDrag
        
    }
    
    //add the 'Back', 'Add', and 'Remove all' button to the navigation bar
    func setupBarButton() {
        let backBarButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButton

        let addBarButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
        let removeAllBarButton = UIBarButtonItem(title: "Remove All", style: .plain, target: self, action: #selector(handleRemoveAll))
        navigationItem.rightBarButtonItems = [addBarButton, removeAllBarButton]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.endEditing(true)
        //change the set ranges array
        let cells = tableView.visibleCells as! [RangeOptionCell]
        for index in 0..<cells.count {
            ranges[index] = (cells[index].min == nil ? Double.leastNormalMagnitude : cells[index].min! , cells[index].max == nil ? Double.greatestFiniteMagnitude : cells[index].max!)
        }

        if let i = index {
            reportOptionController?.ranges[i] = ranges
            if i == 3 {
                if (reportOptionController?.FlagForHbA1cTypes)! {
                    reportOptionController?.HbA1cRangesForIFFC = ranges
                } else {
                    reportOptionController?.HbA1cRangesForNGSP = ranges
                }
            }
        }
    }
    
    func handleAdd() {
        let indexPath = IndexPath(row: numberOfRanges, section: 0)
        numberOfRanges += 1
        ranges.append((Double.leastNormalMagnitude,Double.greatestFiniteMagnitude))
        tableView.insertRows(at: [indexPath], with: .top)
    }
    
    func handleRemoveAll() {
        numberOfRanges = 0
        ranges = []
        DispatchQueue.main.async { 
            self.tableView.reloadData()
        }
        
    }
    
    //setup table cells
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        numberOfRanges -= 1
        ranges.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .bottom)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ranges.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RangeOptionCell()
        if ranges.count > indexPath.row{
            cell.min = ranges[indexPath.row].0
            cell.max = ranges[indexPath.row].1
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
}
