//
//  SignUpViewController.swift
//  Stok Takip
//
//  Created by AHMET HAKAN YILDIRIM on 23.05.2023.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.setHidesBackButton(true, animated: false)
        let backButton = UIBarButtonItem(title: "Geri", style: .plain, target: self, action: #selector(backToWelcomePressed))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc func backToWelcomePressed() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            AuthService.shared.createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }else {
                    self.performSegue(withIdentifier: Constants.registerSegue, sender: self)
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                }
            }
        }
        
        
        
    }
}

