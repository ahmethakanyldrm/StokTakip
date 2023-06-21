//
//  ViewController.swift
//  Stok Takip
//
//  Created by AHMET HAKAN YILDIRIM on 17.05.2023.
//

import AVFoundation
import FirebaseFirestore
import FirebaseStorage
import UIKit



class AddProductViewController: UIViewController, UINavigationControllerDelegate {
    // MARK: - Properties
    
    // Firebase Referance
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var pickedImage: UIImage?
    
    // AvCapture
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet var productNameTextField: UITextField!
    
    @IBOutlet var productPriceTextField: UITextField!
    
    @IBOutlet var productQuantityTextField: UITextField!
    
    @IBOutlet var barcodeLabel: UILabel!
    
    @IBOutlet var productDetailTextField: UITextField!
    
    @IBOutlet var productImageView: UIImageView!
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        let imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        productImageView.addGestureRecognizer(imageTapGestureRecognizer)
        productImageView.isUserInteractionEnabled = true
    }
    
    // ImageView'a tıklandığında galeriyi açma
    @objc func didTapImageView() {
        openPhotoLibrary()
    }
    
    // Kamera butonuna tıklandığında barkod tarama başlatma
    @IBAction func barcodeScannerButton(_ sender: UIBarButtonItem) {
        captureSessionStart()
    }
    
    @IBAction func productAddButton(_ sender: UIButton) {
        
        // Ürün Bilgilerini Al
        guard let productName = productNameTextField.text, !productName.isEmpty else {
            showAlert(withTitle: "Hata", message: "Ürün adı boş olamaz.")
            return
        }
        
        guard let priceString = productPriceTextField.text, let price = Int(priceString) else {
            showAlert(withTitle: "Hata", message: "Geçersiz fiyat.")
            return
        }
        guard let stockString = productQuantityTextField.text, let stock = Int(stockString) else {
            showAlert(withTitle: "Hata", message: "Geçersiz stok adedi.")
            return
        }
        
        guard let details = productDetailTextField.text, !details.isEmpty else {
            showAlert(withTitle: "Hata", message: "Ürün detayı boş olamaz.")
            return
        }
        
        guard let pickedImage = pickedImage, let imageData = pickedImage.jpegData(compressionQuality: 0.8) else {
                   showAlert(withTitle: "Hata", message: "Resim seçmediniz.")
                   return
               }
        
        guard let barcodeValue = barcodeLabel.text, !barcodeValue.isEmpty else {
            showAlert(withTitle: "Hata", message: "Resim seçmediniz.")
            return
        }
        
        
        // Ürün resmini Firebase Storage'a yükleme
          uploadImage(imageData) { [weak self] imageUrl in
            guard let self = self else { return }
            
            let productData: [String: Any] = [
                "productName": productName,
                "detail": details,
                "price": Int(priceString) ?? 0,
                "quantity": Int(stockString) ?? 0,
                "imageUrlString": imageUrl ?? "",
                "barcode": barcodeValue,
            ]
            
            db.collection("products").addDocument(data: productData) { error in
                if let error = error {
                    self.showAlert(withTitle: "Ürün Kaydetme Hatası", message: "\(error.localizedDescription)")
                    return
                }
                self.showAlert(withTitle: "İşlem Başarılı", message: "Ürün Başarıyla Stoğa eklendi.")
                self.productNameTextField.text = nil
                self.productImageView.image = UIImage(named: "select")
                self.productPriceTextField.text = nil
                self.productDetailTextField.text = nil
                self.productQuantityTextField.text = nil
                self.barcodeLabel.text = "Barcode:"
               
            }
        }
        if let homeVC = tabBarController?.viewControllers?[0] as? HomeViewController {
            homeVC.updateTableView()
            navigationController?.pushViewController(homeVC, animated: true)
        }
        
       
    }
    
}
// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension AddProductViewController: AVCaptureMetadataOutputObjectsDelegate {
    // Barkod tarama için AVCaptureSession ayarlama
    private func captureSessionStart() {
        // Barkod okuma işlemine başla
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            showAlert(withTitle: "Hata", message: "Cihazın kamera desteği bulunmuyor.")
            return
        }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            showAlert(withTitle: "Hata", message: "Kamera açılamadı.")
            return
        }
        let metaDataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            showAlert(withTitle: "Hata", message: "Kamera girişi eklenemedi.")
            return
        }

        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)

            metaDataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13, .qr]

        } else {
            showAlert(withTitle: "Hata", message: "Barkod okuma çıktısı eklenemedi.")
            return
        }

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
        captureSession.startRunning()
    }

    // Barkod okunduğunda tetiklenen yöntem
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
                showAlert(withTitle: "Hata", message: "Barkod okunamadı.")
                return
            }

            guard let barcodeValue = readableObject.stringValue else {
                showAlert(withTitle: "Hata", message: "Barkod değeri alınamadı.")
                return
            }

            barcodeLabel.text = barcodeValue
        } else {
            showAlert(withTitle: "Hata", message: "Barkod okunamadı.")
        }

        videoPreviewLayer.removeFromSuperlayer()
    }
}

// MARK: - UIImagePickerControllerDelegate

extension AddProductViewController: UIImagePickerControllerDelegate {
    private func openPhotoLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    // Resim seçildiğinde tetiklenen yöntem

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Seçilen resim alınamadı")
            return
        }

        productImageView.image = selectedImage
        pickedImage = selectedImage
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Show Alert

extension AddProductViewController {
    private func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Firebase işlemleri

extension AddProductViewController {
    // Resmi Firebase Storage'a yükleme
    private func uploadImage(_ imageData: Data, completion: @escaping (String?) -> Void) {
               let storageRef = storage.reference()
               
               let imageRef = storageRef.child("productImages/\(UUID().uuidString).jpg")
               
               let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                   if let error = error {
                       self.showAlert(withTitle: "Hata", message: "Resim yüklenirken hata oluştu: \(error.localizedDescription)")
                       completion(nil)
                       return
                   }
                   
                   imageRef.downloadURL { (url, error) in
                       if let error = error {
                           self.showAlert(withTitle: "Hata", message: "Resim URL'si alınamadı: \(error.localizedDescription)")
                           completion(nil)
                           return
                       }
                       
                       if let imageUrlString = url?.absoluteString {
                           completion(imageUrlString)
                       } else {
                           self.showAlert(withTitle: "Hata", message: "Resim URL'si alınamadı.")
                           completion(nil)
                       }
                   }
               }
               
               uploadTask.resume()
    }
    
}

