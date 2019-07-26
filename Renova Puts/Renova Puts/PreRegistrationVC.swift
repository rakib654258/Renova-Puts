//
//  PreRegistrationVC.swift
//  Renova Puts
//
//  Created by Md Kamrul Hasan on 20/6/19.
//  Copyright © 2019 macOS Mojave. All rights reserved.
//

import UIKit

class PreRegistrationVC: UIViewController {
    
    @IBOutlet weak var fullNameTF: DesignableTextField!
    @IBOutlet weak var userNameTF: DesignableTextField!
    @IBOutlet weak var passTF: DesignableTextField!
    @IBOutlet weak var confPassTF: DesignableTextField!
    
    var fullName : String?
    var userName: String?
    var pass: String?
    var confPass: String?


    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func nextAction(_ sender: UIButton) {
                if let fName = fullNameTF.text, let uName = userNameTF.text, let password = passTF.text, let confirmPassword = confPassTF.text{
        
                    if password != confirmPassword {
                        self.view.makeToast("Wrong Password")
                    }else{
                        
                        fullName = fName
                        userName = uName
                        pass = password
                        
                        UserDefaults.standard.set(password, forKey: "password")
                        
                        fullNameTF.text = ""
                        userNameTF.text = ""
                        passTF.text = ""
                        confPassTF.text = ""
                        
                        performSegue(withIdentifier: "registrationNextSegue", sender: nil)
                    }
                }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registrationNextSegue"
        {
//            let controller = (segue.destination as! UINavigationController).viewControllers[0] as! RegistrationVC
            let controller = segue.destination as! RegistrationVC
            controller.fullName = fullName
            controller.userName = userName
            controller.pass = pass
        }
    }

}
