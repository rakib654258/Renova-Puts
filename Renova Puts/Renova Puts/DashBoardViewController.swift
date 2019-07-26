//
//  DashBoardViewController.swift
//  Renova Puts
//
//  Created by macOS Mojave on 24/5/19.
//  Copyright © 2019 macOS Mojave. All rights reserved.
//

import UIKit

struct Profile: Decodable {
    var id: Int
    var full_name: String
    var username: String
    var email: String
    var image: String
    var user_details: userDetails
}
struct userDetails: Decodable {
    var company_address: String
    var phone_number: String
}

struct Product: Decodable {
    var product__district_name: String
    var Active_point: String
}

class DashBoardViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var name: [String] = []
    var number: [String] = []
    
    @IBOutlet weak var profilePicView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var giftView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var menuView: UIView!
    
    var menuShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Rounded image
        profilePicView.layer.cornerRadius = profilePicView.frame.size.width / 2
        profilePicView.clipsToBounds = true
        
        giftView.layer.cornerRadius = giftView.frame.size.width / 2
        giftView.clipsToBounds = true
        
        menuView.isHidden = true
        sendHader()
        collectionData()
    
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        if menuShow != true {
            menuView.isHidden = false
            menuShow = true
        }else{
            menuView.isHidden = true
            menuShow = false
        }
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "token")
        performSegue(withIdentifier: "signInPageSegue", sender: nil)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if name.count != 0 {
            return name.count
        }else{
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! DashBoardCollectionViewCell
        if name.count != 0 {
            cell.produactNameLabel.text = name[indexPath.row]
            cell.pointlabel.text = "\(number[indexPath.row])"
            
        }
        
        return cell
    }
    
    func sendHader(){
//        user details
        
        let url = URL(string: "http://khanmone.com/mendim_api/userProfile/")!
//        let url = URL(string: url)!
        var request = URLRequest(url: url)
        
//        var request = URLRequest(url: "http://khanmone.com/mendim_api/userProfile/")
        request.setValue("secret-keyValue", forHTTPHeaderField: "secret-key")
        
        let token = UserDefaults.standard.string(forKey: "token")
        
//        request.setValue("Token 1a00483c43514a3d97e5db0e8377b4436c14a3a4", forHTTPHeaderField: "Authorization")
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        var task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let responseString = String(data: data!, encoding: .utf8)
            print("responseString = \(responseString)")
            
            do{
                var data = try JSONDecoder().decode([Profile].self, from: data!)
                
                UserDefaults.standard.set(data[0].id, forKey: "id")
                UserDefaults.standard.set(data[0].full_name, forKey: "full_name")
                UserDefaults.standard.set(data[0].username, forKey: "username")
                UserDefaults.standard.set(data[0].email, forKey: "email")
                UserDefaults.standard.set(data[0].image, forKey: "image")
                UserDefaults.standard.set(data[0].user_details.company_address, forKey: "company_address")
                UserDefaults.standard.set(data[0].user_details.phone_number, forKey: "phone_number")
                
                DispatchQueue.main.async {
                    self.nameLabel.text = data[0].full_name ?? data[0].username
                    self.emailLabel.text = data[0].email
                    self.locationLabel.text = data[0].user_details.company_address
                    
                    let url = URL(string: data[0].image)
                    
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        DispatchQueue.main.async {
                            self.profilePicView.image = UIImage(data: data!)
                        }
                    }
                    
//                    self.profilePicView = data[0].image
                    
                }
                
            }catch let error{
                print("Decode error: ",error)
            }
        }
        
        task.resume()
    }
    
    func collectionData(){
        
        let url = URL(string: "http://khanmone.com/mendim_api/salesInformation/")!
        //        let url = URL(string: url)!
        var request = URLRequest(url: url)
        
        let token = UserDefaults.standard.string(forKey: "token")
//        request.setValue(token, forHTTPHeaderField: "Authorization")
        
//        request.setValue("secret-keyValue", forHTTPHeaderField: "secret-key")
        request.setValue(token, forHTTPHeaderField: "Authorization")

        
        var task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let responseString = String(data: data!, encoding: .utf8)
            print("collection data = \(responseString)")
            
            
            do{
            var datas = try JSONDecoder().decode([Product].self, from: data!)
                
                for i in 0..<datas.count{
                    self.name.append(datas[i].product__district_name)
                    self.number.append(datas[i].Active_point)
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }catch let error{
                print("Decode error: ",error)
            }
            
            
        }
        
        task.resume()
        
    } 
}
