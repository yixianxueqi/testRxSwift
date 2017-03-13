//
//  DMMoyaHttpErrorHandlePlugin.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/13.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import Moya
import Result

//配置MoyaProvider: 自定义插件，用来统一错误处理
class DMMoyaHttpErrorHandlePlugin: PluginType {

    public func didReceive(_ result: Result<Moya.Response, Moya.MoyaError>, target: TargetType) {
    
        print(#function + "\(target)")
        switch result {
        case let .success(response):
            try? print(response.mapJSON())
        case let .failure(error):
            print(error)
        }
    }
}
