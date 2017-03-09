//
//  DMUser.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/8.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import ObjectMapper

class DMUser: Mappable {

    var userName: String?
    var password: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        
        userName <- map["userName"]
        password <- map["password"]
    }
    
}
