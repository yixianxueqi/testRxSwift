//
//  DMLoginService.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/7.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
import RxSwift

//校验
class DMLoginValidationService: DMLoginValidService {
    
    let pwdMinCharacterCount = 6
    let httpService: DMLoginHttpService
    static let validService = DMLoginValidationService()
    private init() {
        httpService = DMLoginHttpServiceImp.httpService
    }
    
    func validationUserName(_ usernName: String) -> Observable<ValidationResult> {
        
        if usernName.characters.count == 0 {
            return .just(.empty)
        }
        if usernName.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "用户名只能包含字母或数字"))
        }
        let result = ValidationResult.validating
//        return Observable<ValidationResult>.just(.ok(message: "用户名可用")).delay(1, scheduler: MainScheduler.instance).startWith(result)
        return httpService.checkUserNameAvaliable(userName: usernName)
        .map({
            if $0 {
                return .ok(message: "用户名可用")
            } else {
                return .failed(message: "用户名已经被占用")
            }
        })
        .startWith(result)
    }
    
    func validationPassword(_ password: String) -> ValidationResult {
        
        let characterCount = password.characters.count
        if characterCount == 0 {
            return .empty
        }
        if characterCount < pwdMinCharacterCount {
            return .failed(message: "密码至少 \(pwdMinCharacterCount) 位")
        }
        return .ok(message: "密码可用")
    }
    
    func validationRepeatPwd(_ pwd: String, repeatPwd: String) -> ValidationResult {
        if repeatPwd.characters.count == 0 {
            return .empty
        }
        if repeatPwd == pwd {
            return .ok(message: "密码一致")
        }
        else {
            return .failed(message: "两次密码不一致")
        }
    }
}

//网络
class DMLoginHttpServiceImp: DMLoginHttpService {
    
    static let httpService = DMLoginHttpServiceImp()
    private init() {}
    let disposeBag = DisposeBag()
    let provider = RxMoyaProvider<DMLoginHttpType>.init(endpointClosure: DMDeployProvider.endpointClosure, manager: DMDeployProvider.defaultAlamofireManager(), plugins: [NetworkLoggerPlugin(), DMMoyaHttpErrorHandlePlugin()])
    
    func checkUserNameAvaliable(userName: String) -> Observable<Bool> {
        
        //原始无缓存版
//        return provider.request(.checkUserName(username: userName))
//            .debug()
//            .distinctUntilChanged()
//            .map {  response in
////                print("response: \(response.request?.url)")
//                return response.statusCode == 404
//            }
//            .catchErrorJustReturn(false)
        //采用缓存版
        return provider
            .tryCache(target: .checkUserName(username: userName), cacheType: .onlyRequest)
            .debug()
            .distinctUntilChanged()
            .map {  response in
                //                print("response: \(response.request?.url)")
                return response.statusCode == 404
            }
            .catchErrorJustReturn(false)
    }
    
    func signUp(userName: String, pwd: String) -> Observable<Bool> {
        //原始无缓存版
//        return provider.request(.signUp(username: userName, pwd: pwd))
//        .debug()
//        .distinctUntilChanged()
//        .mapJSON()
//        .map({ result in
//            let user = DMUser(JSONString: JSON(result)["data"].string!)
//            print("userLogin: \(user?.userName, user?.password)")
//            return true
//        })
//        .catchErrorJustReturn(false)
        //采用缓存版
        return provider
            .tryCache(target: .signUp(username: userName, pwd: pwd), cacheType: .cacheThenRequest)
            .debug()
            .distinctUntilChanged()
            .mapJSON()
            .map({ result in
                let user = DMUser(JSONString: JSON(result)["data"].string!)
                print("userLogin: \(user?.userName, user?.password)")
                return true
            })
            .catchErrorJustReturn(false)
    }
}







