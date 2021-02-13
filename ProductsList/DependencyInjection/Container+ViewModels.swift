//
//  Container+ViewModels.swift
//  ProductsList
//
//  Created by Vahid on 20/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

extension Container {
    func registerViewModels() {
        autoregister(ProductsViewModel.self, initializer: ProductsViewModel.init)
    }
}
