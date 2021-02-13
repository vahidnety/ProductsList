//
//  Container+Services.swift
//  ProductsList
//
//  Created by Vahid on 20/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

extension Container {
    func registerServices() {
        autoregister(ServiceManager.self, initializer: ServiceManager.init).inObjectScope(.container)
        autoregister(NetworkManger.self, initializer: NetworkManger.init).inObjectScope(.container)
        autoregister(DataBaseManger.self, initializer: DataBaseManger.init).inObjectScope(.container)
    }
}
