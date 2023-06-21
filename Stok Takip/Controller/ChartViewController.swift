//
//  ChartViewController.swift
//  Stok Takip
//
//  Created by AHMET HAKAN YILDIRIM on 19.05.2023.
//

import UIKit
import Charts
import FirebaseStorage
import FirebaseFirestore



class ChartViewController: UIViewController, ChartViewDelegate {
      // MARK: - Properties
    var pieChart = PieChartView()
    
    var products: [Product] = []
    
    // Firebase Referance
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        fetchProductsFromFirestore()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.height)
        pieChart.center = view.center
        view.addSubview(pieChart)
        setChartData()
    }
    
    private func setChartData() {
        
        var dataEntries: [ChartDataEntry] = []

              // Verileri döngü ile dolaş ve pie chart için gerekli formatı oluştur
              for (index, product) in products.enumerated() {
                  let entry = PieChartDataEntry(value: Double(product.quantity), label: product.productName)
                  dataEntries.append(entry)
              }
              
              let dataSet = PieChartDataSet(entries: dataEntries, label: "Stok Dağılımı")
              dataSet.colors = ChartColorTemplates.material()
              let data = PieChartData(dataSet: dataSet)
              pieChart.data = data
              let centerText = NSAttributedString(string: "Stok Dağılımı", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0)])
              pieChart.centerAttributedText = centerText
              let labelFont = UIFont.systemFont(ofSize: 20, weight: .bold)
              let labelDescriptor = labelFont.fontDescriptor
              let entryLabelFont = UIFont(descriptor: labelDescriptor, size: 16)
              dataSet.entryLabelFont = entryLabelFont
    }
}

// MARK: - Firebase işlemleri

extension ChartViewController {
    func fetchProductsFromFirestore() {
        db.collection("products").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching products: \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else { return }
            self.products.removeAll()
            for document in snapshot.documents {
                let data = document.data()
                if let productName = document.data()["productName"] as? String,
                   let price = document.data()["price"] as? Int,
                   let quantity = document.data()["quantity"] as? Int,
                   let imageUrlString = document.data()["imageUrlString"] as? String,
                   let barcode = document.data()["barcode"] as? String,
                   let detail = document.data()["detail"] as? String  {
                    let product = Product(productName: productName, detail: detail, price: price, quantity: quantity,imageUrlString: imageUrlString,barcode: barcode)
                    self.products.append(product)
                }
            }
            self.setChartData()
        }
    }
}


