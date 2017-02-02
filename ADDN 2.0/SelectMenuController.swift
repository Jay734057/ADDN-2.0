//
//  SelectMenuController.swift
//  ADDN 2.0
//
//  Created by Jay on 26/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class SelectMenuController: UITableViewController {
    var index:Int?
    
    var items = [String]()
    
    let cellId = "CellId"
    
    var reportOptionController: ReportOptionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem=backBarButton
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
}
