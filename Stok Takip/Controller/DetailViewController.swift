//
//  DetailViewController.swift
//  Stok Takip
//
//  Created by AHMET HAKAN YILDIRIM on 19.05.2023.
//

import UIKit
import FirebaseStorage

class DetailViewController: UIViewController {
    

    // MARK: - Properties
    
    @IBOutlet weak var productDetail: UITextView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
  
    var product: Product?
    let storage = Storage.storage()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
       
        loadData()
    }
    
   
    
    // MARK: - MARK
    
    func loadData(){
        // verileri görüntüleme
        if let product = product {
            productName.text = "\(product.productName)"
            productPrice.text = "Fiyat: \(product.price) ₺"
            productDetail.text = product.detail
            
            let storageRef = storage.reference(forURL: product.imageUrlString ?? "")
            storageRef.getData(maxSize: 1 * 2048 * 2048) { [weak self] data, error in
                if let error = error {
                    self?.showAlert(withTitle: "Resim İndirilirken Bir Hata Oluştu", message: "\(error.localizedDescription)")
                    return
                }
                
                if let imageData = data, let image = UIImage(data: imageData) {
                    self?.productImage.image = image
                }
                
                
            }
        }
    }

}


// MARK: - Helper

extension DetailViewController {
    
    private func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

