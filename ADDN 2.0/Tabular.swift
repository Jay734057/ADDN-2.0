//
//  TableView.swift
//  ADDN 2.0
//
//  Created by Jay on 10/02/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class Tabular : UITableView,UITableViewDelegate,UITableViewDataSource {
    var dataPoint: [String]?
    var values:[[String]]?
    var titles:[String]?
    
    var index = 0
    
    let cellId = "CellId"
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    init(dataPoint: [String], values:[String],titles: [String]) {
        super.init(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: (values.count + 2) * 40  ) , style: .plain)
        self.dataPoint = dataPoint
        self.values = [values]
        self.titles = titles
        
        register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        self.delegate = self
        self.dataSource = self
        
        DispatchQueue.main.async {
            print(self.numberOfRows(inSection: 0))
            self.reloadData()
        }
    }
    
    init(dataPoint: [String], groupedvalues:[[String]],titles: [String]) {
        super.init(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: (groupedvalues.count * (groupedvalues.first?.count)! + 2) * 40  ) , style: .plain)
        self.dataPoint = dataPoint
        self.values = groupedvalues
        self.titles = titles
        
        register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        self.delegate = self
        self.dataSource = self
        
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let headerLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nextButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"right_arrow"), for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let preButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"left_arrow"), for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func handlePrev() {
        if let count = titles?.count{
            index = (index - 1 + count) % count
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    func handleNext() {
        if let count = titles?.count{
            index = (index + 1) % count
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let values = self.values {
            return values[index].count
        }else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if values != nil {
            return 1
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
        cell.textLabel?.text = dataPoint?[indexPath.row]
        cell.detailTextLabel?.text = values?[index][indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 8, height: 30))
        
        header.addSubview(headerLabel)
        //
        headerLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        headerLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        headerLabel.heightAnchor.constraint(equalTo: header.heightAnchor).isActive = true
        
        header.addSubview(nextButton)
        //
        nextButton.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        nextButton.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -6).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        header.addSubview(preButton)
        //
        preButton.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        preButton.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 6).isActive = true
        preButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        preButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        headerLabel.text = titles?[index]
        
        header.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        return header
    }
    
}
