//
//  DMDeployProvider.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/13.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import Moya

class DMDeployProvider {

    //配置MoyaProvider: endPoint
    static let endpointClosure = { (target: DMLoginHttpType) -> Endpoint<DMLoginHttpType> in
        //可在此处对request重新设置属性，如：请求头，请求方式，cookie是否禁用等
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        return defaultEndpoint.adding(newHTTPHeaderFields: ["APP_NAME": "MY_AWESOME_APP"])
    }
    
    //配置MoyaProvider: manager
    static func defaultAlamofireManager() -> Manager {
        //可在此处设置超时时间、https自签名证书等
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 30.0
        let manager = SessionManager(configuration: configuration)
        manager.startRequestsImmediately = true
        return manager
    }
    
}
