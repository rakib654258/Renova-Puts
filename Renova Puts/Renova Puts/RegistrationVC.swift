//
//  RegistrationVC.swift
//  Renova Puts
//
//  Created by Md Kamrul Hasan on 19/6/19.
//  Copyright © 2019 macOS Mojave. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {
    
    @IBOutlet weak var emailTF: DesignableTextField!
    @IBOutlet weak var addressTF: DesignableTextField!
    @IBOutlet weak var phoneTF: DesignableTextField!
    
    var fullName : String?
    var userName: String?
    var pass: String?
    var email: String?
    var address: String?
    var phone: String?
    
    var flag : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        postAction()
        
    }
    
    
    
    @IBAction func createAccount(_ sender: UIButton) {
        
        if let emailF = emailTF.text, let addressF = addressTF.text, let phoneNo = phoneTF.text{

            email = emailF
            address = addressF
            phone = phoneNo
            
            emailTF.text = ""
            addressTF.text = ""
            phoneTF.text = ""
            
            postAction()
        }
        
//        DispatchQueue.main.async {
//            self.performSegue(withIdentifier: "signInSegue", sender: nil)
//        }
//        if flag {
//            self.performSegue(withIdentifier: "signInSegue", sender: nil)
//        }
    }
    
    
    func postAction(){
//    func postAction(url: String, requestType: String, parameters: [String: Any]){
        let url = URL(string: "http://khanmone.com/mendim_api/regAPI/")!
//        let url = URL(string: url)!
        var request = URLRequest(url: url)
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        

        request.httpMethod = "POST"
//        request.httpMethod = requestType
        
        let userDetails: [String:Any] = [
            "company_address": "test",
            "phone_number": "test"
        
        ]
        let parameters: [String: Any] = [
                    "full_name": fullName,
                    "username": userName,
                    "email": email,
                    "password": pass,
                    "user_details": [
                        "company_address": address,
                        "phone_number": phone
                        
                    ]
                ]
        /*
         {
         "full_name": "",
         "username": "",
         "email": "",
         "password":"",
         "user_details": {
         "company_address": "",
         "phone_number": ""
         }
         }
        */
//        let parameters = parameters
//        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
//        let j = try? JSONEncoder().encode(<#T##value: Encodable##Encodable#>)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                self.view.makeToast("Please try with diffrent data")
                return
            }
            self.flag = true
            
//            self.fullNameTF.text = ""
//            self.userNameTF.text = ""
//            self.passTF.text = ""
//            self.confPassTF.text = ""
//            self.emailTF.text = ""
//            self.addressTF.text = ""
//            self.phoneTF.text = ""
            
            
//                        Retrieving String
            
//            let token = UserDefaults.standard.string(forKey: "token") ?? ""
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
            
            
            let responseString = String(data: data, encoding: .utf8)
            print(" Registration responseString = \(responseString)")
            do {
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
        }
        task.resume()
    }
}
