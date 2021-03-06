//
//  DMService3.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/22.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit

public let pageSize = 10

class DMService3: NSObject {
    
    //获取数据
    static func getDataList(page: Int) -> [String] {
        //延迟2.5s,模拟加载数据
        sleep(UInt32(2.5))
        //超过3页，则无更多数据
        if page > 3 {
            return []
        }
        //造假数据
        var list:[String] = []
        while list.count < pageSize {
            let num = Int(arc4random_uniform(10)) + page * 10
            list.append(String(num))
        }
        return list
    }}
