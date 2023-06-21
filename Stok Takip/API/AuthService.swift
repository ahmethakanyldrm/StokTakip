//
//  AuthService.swift
//  Stok Takip
//
//  Created by AHMET HAKAN YILDIRIM on 20.06.2023.
//

import UIKit
import FirebaseAuth


struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping(AuthDataResult?,Error?)->Void) {
        print("DEBUG: Email is \(email), password is \(password)")
        Auth.auth().signIn(withEmail: email, password: password,completion: completion)
        
    }
    
    func createUser(withEmail email: String, password: String, completion: @escaping(AuthDataResult?,Error?)->Void) {
        print("DEBUG: Email is \(email), password is \(password)")
        Auth.auth().createUser(withEmail: email, password: password,completion: completion)
        
    }
    
    
    
}
    
