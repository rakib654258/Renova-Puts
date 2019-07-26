//
//  QRScannerViewController.swift
//  QRCodeReader
//
//  Created by KM, Abhilash a on 08/03/19.
//  Copyright © 2019 KM, Abhilash. All rights reserved.
//

import UIKit

struct qrCheck: Decodable {
    var product: Int?
    var check : Int
    var id : Int?
}


class QRScannerViewController: UIViewController {
    
//    var productData: qrCheck?
    
    var activation : Int?
    var product: Int?
    
    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    @IBOutlet weak var scanButton: UIButton! {
        didSet {
            scanButton.setTitle("STOP", for: .normal)
        }
    }
    
    var qrData: QRData? = nil {
        didSet {
            if qrData != nil {
//                self.performSegue(withIdentifier: "detailSeuge", sender: self)
                sendHader(qrData: (qrData?.codeString)!)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        sendHader(qrData: "REN06-OF7JR7EZ0")
        
        
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }

    @IBAction func scanButtonAction(_ sender: UIButton) {
        scannerView.isRunning ? scannerView.stopScanning() : scannerView.startScanning()
        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
        sender.setTitle(buttonTitle, for: .normal)
    }
    
    
//
    
    func sendHader(qrData: String){
        //        user details
        
        let url = URL(string: "http://khanmone.com/mendim_api/checkActivation/")!
        //        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
//        request.setValue("secret-keyValue", forHTTPHeaderField: "secret-key")
        let token = UserDefaults.standard.string(forKey: "token")
        request.setValue(token, forHTTPHeaderField: "Authorization")
//        request.setValue("REN06-L7K4RRGO7", forHTTPHeaderField: "file")
        
//        let parameters: [String: Any] = [
//                    "file": "REN06-L7K4RRGO7"
//                ]
        let parameters: [String: Any] = [
            "file": qrData
        ]
        
//        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
//        request.httpBody = jsonData
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        var task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let responseString = String(data: data!, encoding: .utf8)
            print("qrCode response = \(responseString)")
            
            do{
                let productData = try JSONDecoder().decode(qrCheck.self, from: data!)
                self.activation = productData.id
                self.product = productData.product
                
                DispatchQueue.main.async{
                    if productData.check == 0 {
                        print("Already Scaned")
                        self.view.makeToast("Already Scaned!", duration: 1.0, position: .center)
                    }else{
                        
                        DispatchQueue.global().async {
//                        self.view.makeToastActivity(.center)
                        
                        self.salesInformationRegister()
                            
                        }
                    }
                }
                
                
                
            }catch let error{
                print("Decode error: ",error)
            }
        }
        
        task.resume()
    }


    func salesInformationRegister(){
        //        user details
//        self.view.hideAllToasts()
        
        let url = URL(string: "http://khanmone.com/mendim_api/salesInformation/")!
        //        let url = URL(string: url)!
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        
        //        request.setValue("secret-keyValue", forHTTPHeaderField: "secret-key")
        let token = UserDefaults.standard.string(forKey: "token")
        request.setValue(token, forHTTPHeaderField: "Authorization")
//        print("productData:",productData)
        
//        var activation = productData!.id
//        var product = productData!.product
        
        let parameters: [String: Any] = [
            "activation": activation as! Int,
            "product": product as! Int
    ]
//            "activation": 62803,
//            "product": 6
//        ]
//        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
//                request.httpBody = jsonData
        
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        var task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            let responseString = String(data: data!, encoding: .utf8)
            print("sales resgister response = \(responseString)")
            self.view.makeToast("Point Added")
//            if error == nil{
//                self.view.makeToast("Point Added")
//
//            }
            
        }
        
        task.resume()
    }


}


extension QRScannerViewController: QRScannerViewDelegate {
    func qrScanningDidStop() {
        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
        scanButton.setTitle(buttonTitle, for: .normal)
    }
    
    func qrScanningDidFail() {
        presentAlert(withTitle: "Error", message: "Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        self.qrData = QRData(codeString: str)
    }
    
    
    
}


extension QRScannerViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "detailSeuge", let viewController = segue.destination as? DetailViewController {
//            viewController.qrData = self.qrData
//        }
//    }
}

