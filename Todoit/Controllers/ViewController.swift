

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    
    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        // Alternative code for this solution - cell.accessoryType = item.done ? .checkmark : .none
        //        cell.accessoryType = item.done == true ? .checkmark : .none
        
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        
        return cell
        
    }
    //MARK: - TableView delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Item
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
                let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                    //what will happen once the user clicks the Add Item button on our UIAlert
                    
                    let newItem = Item(context: self.context)
                    newItem.title = textField.text!
                    newItem.done = false
                    newItem.parentCategory = self.selectedCategory
                    self.itemArray.append(newItem)
                    
                    self.saveItems()
                    
                }
                
                alert.addTextField { alertTextField in
                    alertTextField.placeholder = "Create new item"
                    textField = alertTextField
                    
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                
                
            }
            
            //MARK: - Model Manipulation Methods
            
            func saveItems() {
                
                
                do{
                    try context.save()
                } catch {
                    print("Error saving context \(error)")
                }
                self.tableView.reloadData()
            }
            
            func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
                
                let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
                
                if let additionalPredicate = predicate {
                    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
                } else {
                    request.predicate = categoryPredicate
                }
                

                
                do {
                    itemArray = try context.fetch(request)
                } catch {
                    print("Error fetching data from context \(error)")
                }
                tableView.reloadData()
            }
        }
        //MARK: - Search bar methods

        extension ViewController: UISearchBarDelegate {
            
            func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                let request: NSFetchRequest<Item> = Item.fetchRequest()
                
                let predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
                
                request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                
                
                loadItems(with: request, predicate: predicate)
                
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
