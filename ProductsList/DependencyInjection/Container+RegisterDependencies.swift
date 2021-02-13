//
//  Container+RegisterDependencies.swift
//  ProductsList
//
//  Created by Vahid on 20/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//

import Swinject

extension Container {
    func registerDependencies() {
        registerServices()
        registerViewModels()
    }
}
