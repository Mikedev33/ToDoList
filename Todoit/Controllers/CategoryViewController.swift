

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var categories: Results<Category>?
    var colorCell = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"
       
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].cellColor ?? "#3498db")
    
        return cell

    }
    //MARK: - TableView Dalegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    //MARK: - TableView Manipulation Methods
    
    func save(category: Category) {
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)

        tableView.reloadData()
    
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch {
                print("Error deleting category, \(error)")
            }
        }
    }

    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
                let alert = UIAlertController(title: "Add New Todo Category", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Add", style: .default) { (action) in
                    //what will happen once the user clicks the Add Item button on our UIAlert
                    
                    let newCategory = Category()
                    
                    newCategory.name = textField.text!
                    self.colorCell = self.generateRandomColorString()

                    newCategory.cellColor = self.colorCell
                
                    
                    self.save(category: newCategory)
                }
                
                alert.addTextField { alertTextField in
                    alertTextField.placeholder = "Create new category"
                    textField = alertTextField
                    
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                
                
            }
    
    
            func generateRandomColorString() -> String {
                let red = Int.random(in: 0...255)
                let green = Int.random(in: 0...255)
                let blue = Int.random(in: 0...255)
                return String(format: "#%02X%02X%02X", red, green, blue)
            }
            
            
            
        }
