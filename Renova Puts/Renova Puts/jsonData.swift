//
//  jsonData.swift
//  Renova Puts
//
//  Created by macOS Mojave on 3/6/19.
//  Copyright © 2019 macOS Mojave. All rights reserved.
//

import Foundation

struct registration: Decodable {
    var full_name: String
    var username: String
    var email: String
    var password: String
    var user_details: details
}
struct details: Decodable {
    var company_address: String
    var phone_number: String
}
