//
//  ProductsViewModel.swift
//  ProductsList
//
//  Created by Vahid on 16/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//

import UIKit

// ProductsViewModel does communications with DataBaseManager and ProductsTableViewController
class ProductsViewModel {
    var title: String? = "Products List"
    var products: [Product]? = [Product]()
    // get products data and call for saving into local DB via coreData
    func getProductsData(_ completionBlock: @escaping (_ errorObj: NSError?) -> Void) {
        DataBaseManger.saveProductsToDb { error in
            if error != nil {
                // Show error
                print("show error")
                completionBlock(error)
            } else {
                completionBlock(nil)
            }
        }
    }

    // get products from Local DB via coreData
    func getFromLocalDB(_ completionBlock: @escaping () -> Void) {
        products = DataBaseManger.loadProductsFromDb()
        completionBlock()
    }

    // get filtered products from Local DB via coreData via search input text and sort type
    func getFilteredProductsData(_ sortBy: String, _ searchText: String, _ completionBlock: @escaping () -> Void) {
        let filtered = products?.filter { (product: Product) -> Bool in
            (product.name?.lowercased().contains(searchText.lowercased()))!
        }
        let sortedFiltered = sortBy == "name" ? filtered?.sorted(by: { $0.name! < $1.name! }) : filtered?.sorted(by: { $0.currentPrice < $1.currentPrice })

        guard sortedFiltered != nil else {
            completionBlock()
            return
        }
        products = sortedFiltered
        completionBlock()
    }

    // get sorted products base on sort type as input value
    func getSortedProductsData(_ sortBy: String, _ completionBlock: @escaping () -> Void) {
        let sorted = sortBy == "name" ? products?.sorted(by: { $0.name! < $1.name! }) : products?.sorted(by: { $0.currentPrice < $1.currentPrice })

        guard sorted != nil else {
            completionBlock()
            return
        }
        products = sorted
        completionBlock()
    }
}
