//
//  EditProfileTwoVC.swift
//  Renova Puts
//
//  Created by Md Kamrul Hasan on 21/6/19.
//  Copyright © 2019 macOS Mojave. All rights reserved.
//

import UIKit

class EditProfileTwoVC: UIViewController {

    @IBOutlet weak var emailTF: DesignableTextField!
    @IBOutlet weak var addressTF: DesignableTextField!
    @IBOutlet weak var phoneNoTF: DesignableTextField!
    
    var fullName: String?
    var password: String?
    var confirmPass: String?
    var image : UIImage?
    var id: Int?
    var oldPass : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTF.text = UserDefaults.standard.string(forKey: "email") ?? ""
        addressTF.text = UserDefaults.standard.string(forKey: "company_address") ?? ""
        phoneNoTF.text = UserDefaults.standard.string(forKey: "phone_number") ?? ""
        id = UserDefaults.standard.integer(forKey: "id")
        oldPass = UserDefaults.standard.string(forKey: "password")
        
    }
    
    @IBAction func updateProfileBtn(_ sender: Any) {
        
        if let email = emailTF.text, let address = addressTF.text, let phoneNo = phoneNoTF.text{
            
            //            url one :http://khanmone.com/mendim_api/EditProfileOne/"user id"/
            postAction(url: "http://khanmone.com/mendim_api/EditProfileOne/\(id!)/", requestType: "PUT", parameters: [
                "full_Name": fullName,
                "email": email
                ])
            
            //            url two :
            postAction(url: "http://khanmone.com/mendim_api/EditProfileTwo/\(id!)/", requestType: "PUT", parameters: [
                "company_address": address,
                "phone_number" : phoneNo
                ])
            
            //            url three :
            postAction(url: "http://khanmone.com/mendim_api/ChangePasswordView/\(id!)/", requestType: "PUT", parameters: [
                "old_password": oldPass,
                "new_password": password,
                "retype_password": confirmPass
                ])
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "homeViewSegue", sender: nil)
            }
            
        }
    }
    
    
//    func postAction(){
            func postAction(url: String, requestType: String, parameters: [String: Any]){
//        let url = URL(string: "http://khanmone.com/mendim_api/regAPI/")!
                let url = URL(string: url)!
        var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                let token = UserDefaults.standard.string(forKey: "token")
                request.setValue(token, forHTTPHeaderField: "Authorization")
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
//        request.httpMethod = "POST"
                request.httpMethod = requestType
        
//        let userDetails: [String:Any] = [
//            "company_address": "test",
//            "phone_number": "test"
//
//        ]
//        let parameters: [String: Any] = [
//            "full_name": fullName,
//            "username": userName,
//            "email": email,
//            "password": pass,
//            "user_details": [
//                "company_address": address,
//                "phone_number": phone
//
//            ]
//        ]
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
                let parameters = parameters
//                request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        //        let j = try? JSONEncoder().encode(<#T##value: Encodable##Encodable#>)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                print("find error while updateing data")
                return
            }
            
            guard let data = data else {
                print("find error while updateing data")
                return
            }
            
            
            //                        Retrieving String
            
            //            let token = UserDefaults.standard.string(forKey: "token") ?? ""
            
            
            
            
            let responseString = String(data: data, encoding: .utf8)
            print(" Update responseString = \(responseString)")
            do {
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
        }
        task.resume()
    }
    


}
