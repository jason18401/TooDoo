//
//  ViewController.swift
//  TooDoo
//
//  Created by Jason Yu on 5/6/19.
//  Copyright © 2019 Jason Yu. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {

    //var itemArray = ["Find Food", "Buy Food", "get Food"]
    var itemArray = [Item]()
    
    //filepath for persisting data
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //singleton to access AppDelegate as Object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //to find file location for CoreData
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       // print(dataFilePath)
        
        searchBar.delegate = self
        
        //set array as the updated array
        //if let items = defaults.array(forKey: "TodoListArray") as? [String]{
        //    itemArray = items
        //}
        
        loadItems()
    }

    //Mark - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //called initially when the tableView is loaded up
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if itemArray[indexPath.row].done == true{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    //TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print item into debug console
        print(itemArray[indexPath.row])
        
        //the order matters with these two statements
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: itemArray[indexPath.row])
        
        if itemArray[indexPath.row].done == false{
            itemArray[indexPath.row].done = true
        }else{
            itemArray[indexPath.row].done = false
        }
        
        //does the same thing as the above if-else. Does the opposite of what is set
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //commits the current state of the context
        saveItems()
        
        //turns the highlighted row back to the original color
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context) //Item Object comes from DataModel, type - NSManagedObject
            newItem.title = textField.text! //1 of 2 attributes
            newItem.done = false    //2 of 2 attributes
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        //Adds action to alert
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems(){
        
        do{
            try context.save()
        }catch{
            print("Error saving context: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()){ //Item.fetch... default value so you can call without passing it a value
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
            //load the results into the itemArray
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
    }
    
}

extension ToDoViewController: UISearchBarDelegate{
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
     
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
//        do{
//            //load the results into the itemArray
//            itemArray = try context.fetch(request)
//        }catch{
//            print("Error fetching data from context \(error)")
//        }
        
        //does same thing as above do-catch statement
        loadItems(with: request)
        
    }
    
    //when user presses the x the list gets reloaded
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async { //gets the code running in the background
                searchBar.resignFirstResponder()//no longer currently selected, to get the blinking cursor and keyboard to go away
            }
        }
    }
}

