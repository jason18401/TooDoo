//
//  ViewController.swift
//  TooDoo
//
//  Created by Jason Yu on 5/6/19.
//  Copyright © 2019 Jason Yu. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class ToDoViewController: UITableViewController {

    //var itemArray = ["Find Food", "Buy Food", "get Food"]
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        
        //will happen as soon as it gets set as a value
        didSet{
            loadItems()
        }
    }
    
    //filepath for persisting data
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //singleton to access AppDelegate as Object
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //to find file location for CoreData
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       // print(dataFilePath)
        
        //searchBar.delegate = self
        
        //set array as the updated array
        //if let items = defaults.array(forKey: "TodoListArray") as? [String]{
        //    itemArray = items
        //}
        
        //loadItems() //we dont need it anymore here bc of selectedCategory didSet
    }

    //Mark - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    //called initially when the tableView is loaded up
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = todoItems?[indexPath.row].title
            
            if todoItems?[indexPath.row].done == true{
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print item into debug console
        print(todoItems?[indexPath.row])
        
        //the order matters with these two statements
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: itemArray[indexPath.row])
        
//        if todoItems?[indexPath.row].done == false{
//            todoItems?[indexPath.row].done = true
//        }else{
//            todoItems?[indexPath.row].done = false
//        }
        
        //does the same thing as the above if-else. Does the opposite of what is set
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //commits the current state of the context
//        saveItems()
        
        //turns the highlighted row back to the original color
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                    //did the saving
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        //Adds action to alert
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//    func saveItems(){
//
//        do{
//            try context.save()
//        }catch{
//            print("Error saving context: \(error)")
//        }
//
//        self.tableView.reloadData()
//    }
//
    func loadItems(){ //add predicate param so that the first predicate in extension wont get overwritten
        //Item.fetch... default value so you can call without passing it a value

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

       }
    }
    


//extension ToDoViewController: UISearchBarDelegate{
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
////        do{
////            //load the results into the itemArray
////            itemArray = try context.fetch(request)
////        }catch{
////            print("Error fetching data from context \(error)")
////        }
//
//        //does same thing as above do-catch statement
//        loadItems(with: request, predicate: predicate)
//
//    }
//
//    //when user presses the x the list gets reloaded
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0{
//            loadItems()
//
//            DispatchQueue.main.async { //gets the code running in the background
//                searchBar.resignFirstResponder()//no longer currently selected, to get the blinking cursor and keyboard to go away
//            }
//        }
//    }
//}

