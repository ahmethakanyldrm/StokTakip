//
//  WelcomeViewController.swift
//  Stok Takip
//
//  Created by AHMET HAKAN YILDIRIM on 20.06.2023.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = "⚡️ STOK TAKİP"
        for letter in titleText {
        Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
                    self.titleLabel.text?.append(letter)
                    }
                    charIndex += 1
        
                }
                
      
    }

}
