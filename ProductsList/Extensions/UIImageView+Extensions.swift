//
//  UIImageView+Extensions.swift
//  ProductsList
//
//  Created by Vahid on 17/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//

import Alamofire
import AlamofireImage
import Foundation
import UIKit

extension UIImageView {
    // download image via alamofireimage library with caching
    private func downloadImage(idField: String, imageURL: String) {
        let imageCache = AutoPurgingImageCache(memoryCapacity: 111_111_111, preferredMemoryUsageAfterPurge: 90_000_000)
        image = UIImage(named: "notfound")
        if let image = imageCache.image(withIdentifier: imageURL) {
            self.image = image

        } else {
            AF.request(imageURL).responseImage { response in
                if response.value != nil {
                    let image = UIImage(data: response.data!, scale: 1.0)!
                    imageCache.add(image, withIdentifier: imageURL)
                    self.image = image
                    DispatchQueue.main.async {
                        DataBaseManger.saveImage(identifierField: idField, data: response.data!)
                    }
                }
            }
        }
    }

    // fetchImage via download, caching and if stored from CoreData
    func fetchImage(_ product: Product) {
        if let imgUrl = product.imageUrl {
            let imgData = DataBaseManger.checkImageExist(identifierField: product.identifier.toString())
            if let dt = imgData {
                image = UIImage(data: dt, scale: 1.0)
            } else {
                downloadImage(idField: product.identifier.toString(), imageURL: imgUrl)
            }
        }
    }
}
