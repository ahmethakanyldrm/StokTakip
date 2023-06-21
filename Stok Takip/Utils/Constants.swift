//
//  Constants.swift
//  Stok Takip
//
//  Created by AHMET HAKAN YILDIRIM on 20.06.2023.
//

import Foundation

struct Constants {
    static let appName = "⚡️ STOK TAKİP"
    //static let cellIdentifier = "ReusableCell"
    //static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToLogin"
    static let loginSegue = "LoginToHome"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "products"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
