//
//  ViewController.swift
//  Todoey
//
//  Created by James Tang on 01/18/2020.
//  Copyright (c) James Tang. All rights reserved.
//


import UIKit
import CoreData

class TodoListViewControl: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
           // loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
//
//        let newItem = Item()
//        newItem.done = true
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destory Demogorgon"
//        itemArray.append(newItem3)
//
      
        
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title

        cell.accessoryType = item.done == true ? .checkmark : .none
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // print(itemArray[indexPath.row])
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

      
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
            
            print(self.itemArray)
          
            self.saveItem()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
                textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem(){
     
        
        do{
           try context.save()
        }catch{
            print("Error encoding item array, \(error)")
        }
        self.tableView.reloadData()
    }
    
//    func loadItems(wiith request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
//
//        let categoryPredicate = NSPredicate(format:"parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let addtionalPredicate = predicate{
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
//        }else{
//            request.predicate = categoryPredicate
//        }
//
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch  {
//            print("Error fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
   
    
}
//MARK: - Search bar methods
//extension TodoListViewControl: UISearchBarDelegate{
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(wiith: request, predicate: predicate)
//
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
//
//
//
