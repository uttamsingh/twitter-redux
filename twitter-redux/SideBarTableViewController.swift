//
//  SideBarTableViewController.swift
//  twitter-redux
//
//  Created by Singh, Uttam on 4/19/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit

protocol SideBarTableViewControllerDelegate {
    func sideBarControlDidSelectRow(indexPath: NSIndexPath)
}

class SideBarTableViewController: UITableViewController {
    
    var delegate : SideBarTableViewControllerDelegate?
    var tableData: Array<String> = []

   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell (style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
            
            //Configure the cell here
            cell?.backgroundColor = UIColor.clear
            cell?.textLabel?.textColor = UIColor.darkText
            
            let selectedView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: (cell?.frame.size.width)!, height: (cell?.frame.size.height)!))
            selectedView.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            
            cell?.selectedBackgroundView = selectedView
        }

        // Read the value from table data to populate
        cell?.textLabel?.text = tableData[indexPath.row]
        
        return cell!
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sideBarControlDidSelectRow(indexPath: indexPath as NSIndexPath)
    }
}
