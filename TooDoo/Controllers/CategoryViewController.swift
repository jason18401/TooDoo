//
//  CategoryTableViewController.swift
//  TooDoo
//
//  Created by Jason Yu on 5/20/19.
//  Copyright © 2019 Jason Yu. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()

    var categories : Results<Category>?
    
    //singleton to access AppDelegate as Object
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //Nil Coalescing Operator
        return categories?.count ?? 1   //if categories is not nil return categories.count else return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        
        return cell
    }
    
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //to load up the list relevent to the category
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if we had mutliple segues we can use a if
        let destinationVC = segue.destination as! ToDoViewController
        
        //to identify the current row that is selected
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        //clicks inside the alert
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (field) in
            field.placeholder = "Add a new category"
            textField = field
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Data Manipulation Methods - save and load data
    func save(category : Category){
        
        do{
            //try context.save() //CoreData - try to commit to our context to persistent container
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error in saving Data \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(){
        
        //pulls out Category Objects
        categories = realm.objects(Category.self)
        
//        //need to read data from our context
//        let request : NSFetchRequest<Category> = Category.fetchRequest() //get back all NSFetchRequest Object that uses Category entity
//
//        do{
//            categoryArray = try context.fetch(request)
//        }catch{
//            print("Error loading categories \(error)")
//        }
//
        tableView.reloadData()
   }
    
}
