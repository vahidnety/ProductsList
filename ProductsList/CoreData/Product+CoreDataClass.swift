//
//  Product+CoreDataClass.swift
//  ProductsList
//
//  Created by Vahid on 16/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//
//

import CoreData
import Foundation

@objc(Product)
public class Product: NSManagedObject {
    func parseData(data: [String: Any]) {
        identifier = (data["identifier"] as? Double)!
        name = (data["name"] as? String)!
        brand = (data["brand"] as? String)!
        originalPrice = (data["original_price"] as? Double)!
        currentPrice = (data["current_price"] as? Double)!
        currency = (data["currency"] as? String)!
        note = (data["note"] as? String) ?? "-"

        if let imgUrl = data["image"] as? [String: Any] {
            imageUrl = (imgUrl["url"] as? String)!
        }
    }
}
