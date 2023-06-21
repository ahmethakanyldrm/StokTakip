//
//  HomeViewController.swift
//  Stok Takip
//
//  Created by AHMET HAKAN YILDIRIM on 17.05.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    let tableView = UITableView()

    var products: [Product] = []
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var selectedRowIndex: Int?
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setup()
        fetchProducts()
        updateTableView()
    }
    
   
    
    // MARK: - Selector
    
     func updateTableView() {
        tableView.reloadData()
    }
    
    private func fetchProducts() {
        db.collection("products").getDocuments { [weak self] snapshot, error in
            guard let self = self else {return}
            if let error = error {
                self.showAlert(withTitle: "Veri Alınırken Hata Oluştu", message: "\(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("Belge bulunamadı")
                return
            }
            self.products.removeAll()
            for document in documents {
                if let productName = document.data()["productName"] as? String,
                   let price = document.data()["price"] as? Int,
                   let quantity = document.data()["quantity"] as? Int,
                   let imageUrlString = document.data()["imageUrlString"] as? String,
                   let barcode = document.data()["barcode"] as? String,
                   let detail = document.data()["detail"] as? String
                {
                    
                    let product = Product(productName: productName, detail: detail, price: price, quantity: quantity, imageUrlString: imageUrlString, barcode: barcode)
                    self.products.append(product)
                    
                }
                   
            }
            
            self.updateTableView()
        }
    }
  
}


// MARK: - UITableViewDelegate - And Stepper
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let product = products[indexPath.row]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        detailVC.product = product
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        let product = products[indexPath.row]
        cell.productName.text = product.productName
        cell.productBarcode.text = "Barcode: \(product.barcode ?? "BARKOD YOK")"
        cell.productPrice.text = "Fiyat: \(product.price) ₺"
        cell.productQuantity.text = "Stok Adedi: \(product.quantity)"
        
        // firebase storage dan resim çekme
        let storageRef = storage.reference(forURL: product.imageUrlString ?? "")
        storageRef.getData(maxSize: 1 * 2048 * 2048) { data, error in
            if let error = error {
                self.showAlert(withTitle: "Resim indirilirken hata oluştu", message: "\(error.localizedDescription)")
                return
            }
            if let imageData = data, let image = UIImage(data: imageData) {
                cell.productImage.image = image
                cell.setNeedsLayout()
                
            }
        }
        return cell
    }
    
    
    private func setup() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 200
    }
    
}


extension HomeViewController {
    private func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
