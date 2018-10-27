//
//  CoreDataStack.swift
//  ToDoApp
//
//  Created by Lucas Dahl on 10/26/18.
//  Copyright © 2018 Lucas Dahl. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    var container: NSPersistentContainer {
        let container = NSPersistentContainer(name: "Todos")
        container.loadPersistentStores { (description, error) in
            
            guard error == nil else {
                print("Erroe: \(error!)")
                return
            }
        }
        
        return container
        
    }
    
    var managedContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}
