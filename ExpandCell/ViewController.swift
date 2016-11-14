//
//  ViewController.swift
//  ExpandCell
//
//  Created by Mac on 9/27/16.
//  Copyright © 2016 劉 仲軒. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    // MARK : -> Data
    struct Section {
        var name = String()
        var item = [String]()
        var collapsed = Bool()
        
        init(name: String, item: [String], collapsed: Bool = true) {
            self.name = name
            self.item = item
            self.collapsed = collapsed
        }
    }
    
    var sections = [Section]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sections = [
            Section(name: "Mac", item: ["MacBook", "MacBook Air", "MacBook Pro", "iMac", "Mac Pro", "Mac mini", "Accessories", "OS X El Capitan"]),
            Section(name: "iPad", item: ["iPad Pro", "iPad Air 2", "iPad mini 4", "Accessories"]),
            Section(name: "iPhone", item: ["iPhone 6s", "iPhone 6", "iPhone SE", "Accessories"])
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // SetUp Number of Sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    // SetUp Titles
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Manufacture"
        case 1:
            return "Products"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        // For section 1, the total count is items count plus the number of headers
        var count = sections.count
        
        for section in sections {
            count += section.item.count
        }
        
        return count
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return tableView.rowHeight
        }
        
        // Calculate the real section index and row index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        // Header has fixed height
        if row == 0 {
            return 50.0
        }
        
        return sections[section].collapsed ? 0 : 44.0
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("title") as UITableViewCell!
            cell.textLabel?.text = "Apple"
            return cell
        }
        
        // Calculate the real section index and row index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        if row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("header") as! HeaderCell
            cell.titleLabel.text = sections[section].name
            cell.toggleButton.tag = section
            cell.toggleButton.setTitle(sections[section].collapsed ? "+" : "-", forState: .Normal)
            cell.toggleButton.addTarget(self, action: #selector(ViewController.toggleCollapse(_:)), forControlEvents: .TouchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
            cell.textLabel?.text = sections[section].item[row - 1]
            return cell
        }
    }
    
    // MARK: - Event Handlers
    func toggleCollapse(sender: UIButton) {
        let section = sender.tag
        let collapsed = sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = !collapsed
        
        let indices = getHeaderIndices()
        
        let start = indices[section]
        let end = start + sections[section].item.count
        
        tableView.beginUpdates()
        for i in start ..< end + 1 {
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 1)], withRowAnimation: .Automatic)
        }
        tableView.endUpdates()
    }

    
    // MARK: - Helper Functions
    func getSectionIndex(row: NSInteger) -> Int {
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                return i
            }
        }
        
        return -1
    }
    
    func getRowIndex(row: NSInteger) -> Int {
        var index = row
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                index -= indices[i]
                break
            }
        }
        
        return index
    }
    
    func getHeaderIndices() -> [Int] {
        var index = 0
        var indices: [Int] = []
        
        for section in sections {
            indices.append(index)
            index += section.item.count + 1
        }
        
        return indices
    }

    
}

