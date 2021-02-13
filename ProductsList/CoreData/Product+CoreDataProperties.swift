//
//  Product+CoreDataProperties.swift
//  ProductsList
//
//  Created by Vahid on 16/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//
//

import CoreData
import Foundation

public extension Product {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Product> {
        NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged var identifier: Double
    @NSManaged var name: String?
    @NSManaged var brand: String?
    @NSManaged var originalPrice: Double
    @NSManaged var currentPrice: Double
    @NSManaged var imageUrl: String?
    @NSManaged var currency: String?
    @NSManaged var note: String?
    @NSManaged var img: Data?
}
