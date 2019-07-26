//
//  RewardViewController.swift
//  Renova Puts
//
//  Created by macOS Mojave on 24/5/19.
//  Copyright © 2019 macOS Mojave. All rights reserved.
//http://khanmone.com/mendim_api/Reward/

import UIKit

struct Reward: Decodable {
    var user_Message: String
    var offers: Offers
    var read_flag: Bool
}
struct Offers:Decodable {
    var image_offer: String
    var image_details: String
}

class RewardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var name: [String] = []
    var img: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorColor = UIColor.clear
        
        sendHader()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if name.count != 0{
            return name.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! RewardTableViewCell
        // Configure the cell...
        if img.count != 0{
//            let image = img[indexPath.row]
//            cell.imgView.image = UIImage(named: image)
            
            let url = URL(string: img[indexPath.row])
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    cell.imgView.image = UIImage(data: data!)
                }
            }
            
            cell.nameView.text = name[indexPath.row]
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func sendHader(){
        //        user details
        
        let url = URL(string: "http://khanmone.com/mendim_api/Reward/")!
        //        let url = URL(string: url)!
        var request = URLRequest(url: url)
        
//        let token = UserDefaults.standard.string(forKey: "token") ?? ""
//        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        request.setValue("secret-keyValue", forHTTPHeaderField: "secret-key")
//        request.setValue("Token 1a00483c43514a3d97e5db0e8377b4436c14a3a4", forHTTPHeaderField: "Authorization")
//        Token 43eb9961f5071cbf99d89408d1ea6e65fc7ec4e3
        
        let token = UserDefaults.standard.string(forKey: "token")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        var task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let responseString = String(data: data!, encoding: .utf8)
            print("responseString = \(responseString)")
            
            do{
                var datas = try JSONDecoder().decode([Reward].self, from: data!)
                
                for index in 0..<datas.count{
                    self.name.append(datas[index].offers.image_details)
                    self.img.append(datas[index].offers.image_offer)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }catch let error{
                print("Decode error: ",error)
            }
        }
        
        task.resume()
    }


}
