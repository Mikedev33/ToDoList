

import UIKit
import RealmSwift

class ViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let colourHex = selectedCategory?.cellColor {
            
            title = selectedCategory!.name
            
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
            
            
            // Create and configure the appearance
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground() // Ensures it works well with solid colors
            appearance.backgroundColor = UIColor(hexString: colourHex)
            
            // Change the text color of the navigation bar
            appearance.titleTextAttributes = [.foregroundColor: UIColor(hexString: colourHex)!.contrastColor()]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(hexString: colourHex)!.contrastColor()]
            
            // Apply the appearance to the navigation bar
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            navBar.tintColor = UIColor(hexString: colourHex)!.contrastColor()
            
            addButton.tintColor = UIColor(hexString: colourHex)!.contrastColor()
            searchBar.barTintColor = UIColor(hexString: colourHex)
            searchBar.searchTextField.backgroundColor = UIColor.white
            
            
        }
    }
    
    
    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            
            if let totalItems = todoItems?.count {
                let alphaValue = 1.0 - (CGFloat(indexPath.row) / CGFloat(totalItems))
                
                let categoryColorOptional = UIColor(hexString: selectedCategory?.cellColor ?? "#3498db")
                
                if let categoryColor = categoryColorOptional {
                    let colorAlfa = categoryColor.withAlphaComponent(alphaValue)
                    cell.backgroundColor = colorAlfa
                    cell.textLabel?.textColor = colorAlfa.contrastColor()
                }
                
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
    //MARK: - TableView delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    // Delete with realm
                    //                    realm.delete(item)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Item
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        
                        
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
                
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Model Manipulation Methods
    
    //            func saveItems() {
    //                
    //                
    //                do{
    //                    try context.save()
    //                } catch {
    //                    print("Error saving context \(error)")
    //                }
    //                self.tableView.reloadData()
    //            }
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        print("Item for deletion: (itemForDeletion.title)")
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            print ("works as you think")
            print("Item for deletion: \(itemForDeletion.title)")
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            }catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    
}




//MARK: - Search bar methods

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
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
