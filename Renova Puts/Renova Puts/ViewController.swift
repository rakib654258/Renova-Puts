//
//  ViewController.swift
//  Renova Puts
//
//  Created by macOS Mojave on 22/5/19.
//  Copyright © 2019 macOS Mojave. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct Token: Decodable {
        let token: String
    }

    var finalToken: String?
    
    @IBOutlet weak var userNameTF: DesignableTextField!
    
    @IBOutlet weak var passwordTF: DesignableTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func postAction(url: String, requestType: String, parameters: [String: Any]){
//        let url = URL(string: "http://khanmone.com/mendim_api/loginAPI/")!
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
        request.httpMethod = requestType
//        let parameters: [String: Any] = [
//            "username": "iosadmin",
//            "password": "iosadmin"
//        ]
        let parameters = parameters
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
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
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            do {
                
                let token = try JSONDecoder().decode(Token.self, from: data)
                print(token)
                self.finalToken = "Token \(token.token)"
                print("finalToken = ",self.finalToken!)
                
                DispatchQueue.main.async {
                    if let token = self.finalToken {
                        print("enter Segue block")
                        
//                        set UserDefaults
                        UserDefaults.standard.set(token, forKey: "token" )
//                        UserDefaults.standard.set(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
                        
//                        Retrieving String
//                        let name = UserDefaults.standard.string(forKey: “name”) ?? “”

//                        delete UserDefaults data
//                        UserDefaults.standard.removeSuite(named: "token")
                        
                        self.performSegue(withIdentifier: "homePageSegue", sender: self)
                    }
                    
                }

                
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
            
        }
        
        task.resume()
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        var url = "http://khanmone.com/mendim_api/loginAPI/"
        var requestType = "POST"
        
        if let userName = userNameTF.text, let password = passwordTF.text{
            
            let parameters: [String: Any] = [
                "username": userName,
                "password": password
            ]
            
            postAction(url: url, requestType: requestType, parameters: parameters)
        }
      
    }
    
    
    
    
    
        
    
    
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

