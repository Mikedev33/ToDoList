//
//  AppDelegate.swift
//  Todoit
//
//  Created by Mischa on 10.11.24.
//

import UIKit
import CoreData
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//            // Realm migration configuration
//            let config = Realm.Configuration(
//                schemaVersion: 2, // Increment the schema version
//                migrationBlock: { migration, oldSchemaVersion in
//                    if oldSchemaVersion < 2 {
//                        // Perform migration for new schema
//                        migration.enumerateObjects(ofType: Item.className()) { _, newObject in
//                            newObject?["dateCreated"] = Date().timeIntervalSince1970
//                        }
//                    }
//                }
//            )
//
//            // Set this as the default configuration
//            Realm.Configuration.defaultConfiguration = config
//
//            // Initialize Realm (optional to force the configuration load)
//            do {
//                _ = try Realm()
//            } catch {
//                print("Error initializing Realm: \(error)")
//            }
//
//            return true
//        }
        
        
        do {
            let realm = try Realm()
        } catch {
            print("Error inittialising new realm, \(error)")
        }
        
        return true
    }
    

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
       
    }

    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Todoit")
        
//        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
//        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    

}
