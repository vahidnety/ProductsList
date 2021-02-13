//
//  DataBaseManger.swift
//  ProductsList
//
//  Created by Vahid on 16/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//

import CoreData
import Foundation
import UIKit

// Class related to the Database related things
class DataBaseManger: NSObject {
    // save into DB
    class func saveProductsToDb(_ completionBlock: @escaping (_ errorObj: NSError?) -> Void) {
        ServiceManager.loadProducts { response, error in
            if response != nil {
                if let productPage = checkRecordExists(entity: "ProductPage") {
                    productPage.parseWith(response: response ?? [String: Any]())
                }
                completionBlock(nil)
            } else {
                // Do nothing -  no error, response is empty
                print("Do nothing -  no error, response is empty")
            }
            if error != nil {
                // Show error
                print("show error")
                completionBlock(error)
            }
        }
        // check record exist or not base on entity
        func checkRecordExists(entity: String) -> ProductPage? {
            let context = CoreDataManager.sharedManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
            var results: [NSManagedObject] = []
            do {
                results = try context.fetch(fetchRequest)
            } catch {
                print("error executing fetch request: \(error)")
            }
            if let result = results.first {
                return result as? ProductPage
            } else {
                guard let entity1 = NSEntityDescription.entity(forEntityName: "ProductPage", in: context) else {
                    return nil
                }
                let productPage = NSManagedObject(entity: entity1, insertInto: context) as? ProductPage
                return productPage
            }
        }
    }

    // load products from DB CoreData
    class func loadProductsFromDb() -> [Product] {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext

        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Product")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        var viewModelArray = [Product]()

        do {
            let products = try context.fetch(fetchRequest)
            for item in products as [NSManagedObject] {
                viewModelArray.append(item as! Product)
            }

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return viewModelArray
    }

    // update note record of specific product item of identifierField
    class func updateNote(noteField: String, identifierField: String) {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", identifierField)

        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(fetchRequest) as! [NSManagedObject]
        } catch {
            print("error executing fetch request: \(error)")
        }
        if results.count > 0 {
            let managedObject = results[0]
            managedObject.setValue(noteField, forKey: "note")

            do {
                try context.save()
            } catch {
                print("error executing save request: \(error)")
            }
        }
    }

    // save image into DB CoreData
    class func saveImage(identifierField: String, data: Data) {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", identifierField)

        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(fetchRequest) as! [NSManagedObject]
        } catch {
            print("error executing fetch request: \(error)")
        }
        if results.count > 0 {
            let managedObject = results[0]
            managedObject.setValue(data, forKey: "image")
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("error executing save request: \(error)")
                }
            }
        }
    }

    // check existence of the image for that identifierField record or product
    class func checkImageExist(identifierField: String) -> Data? {
        var res = Data()
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", identifierField)
        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(fetchRequest) as! [NSManagedObject]
        } catch {
            print("error executing fetch request: \(error)")
        }
        if results.count > 0 {
            let managedObject = results[0]
            guard let imgData = managedObject.value(forKey: "image") else { return nil }
            res = imgData as! Data
        }
        return res
    }
}
