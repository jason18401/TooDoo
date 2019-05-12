//
//  ViewController.swift
//  TooDoo
//
//  Created by Jason Yu on 5/6/19.
//  Copyright © 2019 Jason Yu. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {

    let itemArray = ["Find Food", "Buy Food", "get Food"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //Mark - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print item into debug console
        print(itemArray[indexPath.row])
        
        //to add a checkmark
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            //to deselect checkmark if it is already checked
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            //add checkmark if not checked
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //turns the highlighted row back to the original color
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

