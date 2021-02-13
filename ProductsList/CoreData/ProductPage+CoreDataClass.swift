//
//  ProductPage+CoreDataClass.swift
//  ProductsList
//
//  Created by Vahid on 16/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//
//

import CoreData
import Foundation

@objc(ProductPage)
public class ProductPage: NSManagedObject {
    func parseWith(response: [String: Any]) {
        if let products = response["products"] as? [[String: Any]] {
            var productsArray = [Product]()
            for item in products {
                if let itemId = item["identifier"] as? Double {
                    if let itemObj = checkRecordExists(entity: "Product", uniqueIdentity: itemId, idAttributeName: "identifier") {
                        itemObj.parseData(data: item)
                        productsArray.append(itemObj)
                    }
                }
                self.products = NSSet(array: productsArray)
            }
            CoreDataManager.sharedManager.saveContext()
        }
    }

    func checkRecordExists(entity: String, uniqueIdentity: Double, idAttributeName: String) -> Product? {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "\(idAttributeName) == %f", uniqueIdentity)

        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(fetchRequest)
        } catch {
            print("error executing fetch request: \(error)")
        }
        if let result = results.first {
            return result as? Product
        } else {
            guard let entity1 = NSEntityDescription.entity(forEntityName: "Product", in: context) else {
                return nil
            }
            let product = NSManagedObject(entity: entity1, insertInto: context) as? Product
            return product
        }
    }
}
