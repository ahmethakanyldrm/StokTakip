//
//  HomeTableViewCell.swift
//  Stok Takip
//
//  Created by AHMET HAKAN YILDIRIM on 20.06.2023.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    let productImage = UIImageView()
    let productName = UILabel()
    let productPrice = UILabel()
    let productQuantity = UILabel()
    let productBarcode = UILabel()
   

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(productImage)
        addSubview(productName)
        addSubview(productPrice)
        addSubview(productQuantity)
        addSubview(productBarcode)
        
        
        productImage.frame = CGRect(x: 10, y: 10, width: 140, height: 140)
        productName.frame = CGRect(x: 160, y: 10, width: 150, height: 30)
        productPrice.frame = CGRect(x: 160, y: 60, width: 150, height: 30)
        productQuantity.frame = CGRect(x: 160, y: 110, width: 150, height: 30)
        productBarcode.frame = CGRect(x: 160, y: 160, width: 150, height: 30)
        
        
        productName.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        productPrice.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        productQuantity.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        productBarcode.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        
        productImage.clipsToBounds = true
        productImage.layer.cornerRadius = productImage.frame.height / 2
        
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
