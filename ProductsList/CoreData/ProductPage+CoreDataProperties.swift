//
//  ProductPage+CoreDataProperties.swift
//  ProductsList
//
//  Created by Vahid on 16/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//
//

import CoreData
import Foundation

public extension ProductPage {
    @nonobjc class func fetchRequest() -> NSFetchRequest<ProductPage> {
        NSFetchRequest<ProductPage>(entityName: "ProductPage")
    }

    @NSManaged var products: NSSet?
}

// MARK: Generated accessors for products

public extension ProductPage {
    @objc(addProductsObject:)
    @NSManaged func addToProducts(_ value: Product)

    @objc(removeProductsObject:)
    @NSManaged func removeFromProducts(_ value: Product)

    @objc(addProducts:)
    @NSManaged func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged func removeFromProducts(_ values: NSSet)
}
