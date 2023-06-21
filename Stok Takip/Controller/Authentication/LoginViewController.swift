//
//  LoginViewController.swift
//  Stok Takip
//
//  Created by AHMET HAKAN YILDIRIM on 20.06.2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
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
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            AuthService.shared.logUserIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else {return}
                
                if let e = error {
                    print(e.localizedDescription)
                }else {
                    strongSelf.performSegue(withIdentifier: Constants.loginSegue, sender: strongSelf)
                }
            }
            
    }
    }
    
}
