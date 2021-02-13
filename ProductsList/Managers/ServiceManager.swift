//
//  ServiceManager.swift
//  ProductsList
//
//  Created by Vahid on 16/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//

import Foundation
import UIKit

// ServiceManager class for service layer
class ServiceManager: NSObject {
    class func loadProducts(_ completionBlock: @escaping (_ responseArray: [String: Any]?, _ errorObj: NSError?) -> Void) {
        NetworkManger.requestForType(serviceType: ServiceType.serviceloadProducts, params: nil) { response, error in
            if let error = error {
                completionBlock(nil, error)
            } else if let response = response {
                completionBlock(response, nil)
            }
        }
    }
}
