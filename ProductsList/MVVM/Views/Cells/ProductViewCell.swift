//
//  ProductTableViewCell.swift
//  ProductsList
//
//  Created by Vahid on 16/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//

import UIKit

// Product View Cell
class ProductViewCell: UITableViewCell {
    @IBOutlet var productImgView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var brandLbl: UILabel!
    @IBOutlet var originalPriceLbl: UILabel!
    @IBOutlet var currentPriceLbl: UILabel!
    @IBOutlet var noteLbl: UILabel!
    @IBOutlet var originalPriceSV: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productImgView.clipsToBounds = true
        productImgView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// updateData into local DB
    /// - Parameter item: item is one element as product object
    func updateData(item: Product) {
        nameLbl.text = item.name
        brandLbl.text = item.brand
        originalPriceLbl.text = item.originalPrice.toString() + " " + item.currency!
        currentPriceLbl.text = item.currentPrice.toString() + " " + item.currency!
        noteLbl.text = item.note
        if originalPriceLbl.text == currentPriceLbl.text {
            // hide original price StackView
            originalPriceSV.isHidden = true
        }
        // fetchImage via download, caching and if stored from CoreData
        productImgView.fetchImage(item)
    }
}
