//
//  ViewController.swift
//  Todoey
//
//  Created by James Tang on 01/18/2020.
//  Copyright (c) James Tang. All rights reserved.
//


import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewControl: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var todoItem: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
           loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
              
       
        tableView.separatorStyle = .none
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.name
        
        
        if let colorHex = selectedCategory?.colour{
            
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor(hexString: colorHex)
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller dones not exits.")}
            
            if let navBarColor = UIColor(hexString: colorHex){
              
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.scrollEdgeAppearance = navBarAppearance
                navBar.standardAppearance = navBarAppearance
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
                searchBar.barTintColor = navBarColor
                
              
            }
           
            
           

        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row ) / CGFloat( todoItem!.count)){
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
        }
        
        if let item = todoItem?[indexPath.row] {
            cell.textLabel?.text = item.title
            

            cell.accessoryType = item.done == true ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Item Added"
        }
        
       
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItem?[indexPath.row]{
            do {
                try realm.write{
                   // realm.delete(item)
                   item.done = !item.done
                }
            } catch  {
                print("Erro saving done status, \(error)")
            }
        }
        
//        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

      
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)

                    }
                } catch  {
                    print("Error saving new items, \(error)")
                }
            }
           

           
            self.tableView.reloadData()
          
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
                textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
   
    
    func loadItems(){
        
        todoItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItem?[indexPath.row]{
            do {
                try realm.write{
                    realm.delete(item)
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
    }
    
}
//MARK: - Search bar methods
extension TodoListViewControl: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItem = todoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}



