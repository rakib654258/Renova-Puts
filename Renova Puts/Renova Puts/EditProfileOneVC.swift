//
//  EditProfileOneVC.swift
//  Renova Puts
//
//  Created by Md Kamrul Hasan on 21/6/19.
//  Copyright © 2019 macOS Mojave. All rights reserved.
//

import UIKit

class EditProfileOneVC: UIViewController {
    
    
    @IBOutlet weak var profilePicView: UIImageView!
    
    @IBOutlet weak var fullNameTF: DesignableTextField!
    @IBOutlet weak var userNameTF: DesignableTextField!
    @IBOutlet weak var passwordTF: DesignableTextField!
    @IBOutlet weak var confirmPasswordTF: DesignableTextField!
    
    var id : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Rounded image
        profilePicView.layer.cornerRadius = profilePicView.frame.size.width / 2
        profilePicView.clipsToBounds = true
        
//        let token = UserDefaults.standard.string(forKey: "token")
        
        fullNameTF.text = UserDefaults.standard.string(forKey: "full_name")
        userNameTF.text = UserDefaults.standard.string(forKey: "username")
        userNameTF.isEnabled = false
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        performSegue(withIdentifier: "nextSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextSegue"{
            if let sendData = segue.destination as? EditProfileTwoVC{
                if let fName = fullNameTF.text, let uName = userNameTF.text, let password = passwordTF.text, let cPassword = confirmPasswordTF.text, let image = profilePicView.image {
                    sendData.fullName = fName
                    sendData.password = password
                    sendData.confirmPass = cPassword
//                    sendData.provideImageData(<#T##data: UnsafeMutableRawPointer##UnsafeMutableRawPointer#>, bytesPerRow: <#T##Int#>, origin: <#T##Int#>, <#T##y: Int##Int#>, size: <#T##Int#>, <#T##height: Int##Int#>, userInfo: <#T##Any?#>)
                }else{
                    self.view.makeToast("Please Fill the text field")
                }
            }
        }
    }
    
    

}
