//
//  CoreDataManager.swift
//  ProductsList
//
//  Created by Vahid on 16/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class CoreDataManager {
    static let sharedManager = CoreDataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Products")

        container.loadPersistentStores(completionHandler: { _, error in

            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
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
