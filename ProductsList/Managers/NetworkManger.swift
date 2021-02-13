//
//  NetworkManger.swift
//  ProductsList
//
//  Created by Vahid on 16/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//

import Alamofire
import AlamofireImage
import Foundation

// Classes related to the Network layer

enum ServiceType: URLConvertible {
    case serviceloadProducts // Add more calls later

    func asURL() throws -> URL {
        URL(string: URLString)!
    }

    var URLString: String {
        switch self {
        case .serviceloadProducts:
            let products = "http://api.mocki.io/v1/a71b7e35" // ?"https://private-91dd6-iosassessment.apiary-mock.com/products"
            return products
        }
    }

    var requestMethod: Alamofire.HTTPMethod {
        switch self {
        case .serviceloadProducts:
            return .get
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .serviceloadProducts:
            var values: HTTPHeaders = ["Content-Type": "application/json"]
            values["Accept-Encoding"] = "gzip"
            return values
        }
    }
}

class NetworkManger: NSObject {
    class func requestForType(serviceType: ServiceType, params: [String: Any]?, completionBlock: @escaping (_ response: [String: Any]?, _ error: NSError?) -> Void) {
        AF.request(serviceType.URLString, method: serviceType.requestMethod, parameters: params, encoding: URLEncoding.default, headers: serviceType.headers).responseJSON { response in
            DispatchQueue.main.async {
                switch response.result {
                case let .success(value):
                    if value is NSNull {
                        completionBlock([String: Any](), nil)
                        return
                    }
                    let responseValue = value as? [String: AnyObject]
                    completionBlock(responseValue, nil)
                case let .failure(error):
                    if response.response?.statusCode == 304 {
                        completionBlock([String: Any](), nil)
                    } else {
                        print(Error.self)
                        completionBlock(nil, error as NSError)
                    }
                }
            }
        }
    }
}
