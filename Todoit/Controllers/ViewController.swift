

import UIKit
import RealmSwift

class ViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
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
