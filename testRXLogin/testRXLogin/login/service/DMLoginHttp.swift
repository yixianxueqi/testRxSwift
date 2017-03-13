//
//  DMLoginHttp.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/8.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import Moya
import RxSwift

enum DMLoginHttpType {
    case checkUserName(username: String)
    case signUp(username: String, pwd: String)
}

extension DMLoginHttpType: TargetType {

    var baseURL: URL {
        switch self {
        case .checkUserName:
            return URL.init(string: "https://github.com/")!
        default:
            return URL.init(string: "https://httpbin.org/")!
        }
    }
    var path: String {
        switch self {
        case let .checkUserName(username):
            return username
        default:
            return "post"
        }
    }
    var method: Moya.Method {
        switch self {
        case .checkUserName:
            return .get
        default:
            return .post
        }
    }
    var parameters: [String : Any]? {
        switch self {
        case .checkUserName:
            return nil
        case let .signUp(username, pwd):
            return ["userName": username, "password": pwd]
        }
    }
    var sampleData: Data {
        switch self {
        case .checkUserName:
            return "checkusername".data(using: String.Encoding.utf8)!
        case .signUp:
            return "signUp".data(using: String.Encoding.utf8)!
        }
    }
    var task: Task {
        return .request
    }
    var validate: Bool {
        return false
    }
    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .checkUserName:
            return URLEncoding.default
        case .signUp:
            return JSONEncoding.default
        }
    }
}










