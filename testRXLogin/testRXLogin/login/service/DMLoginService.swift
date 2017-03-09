//
//  DMLoginService.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/7.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import SwiftyJSON

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
    let provider = RxMoyaProvider<DMLoginHttpType>()
    let disposeBag = DisposeBag()
    
    func checkUserNameAvaliable(userName: String) -> Observable<Bool> {
        
        return provider.request(.checkUserName(username: userName))
            .debug()
            .map {  response in
//                print("response: \(response.request?.url)")
                return response.statusCode == 404
            }
            .catchErrorJustReturn(false)
    }
    
    func signUp(userName: String, pwd: String) -> Observable<Bool> {
        
        return provider.request(.signUp(username: userName, pwd: pwd))
        .debug()
        .mapJSON()
        .map({ result in
            let user = DMUser(JSONString: JSON(result)["data"].string!)
            print("userLogin: \(user?.userName, user?.password)")
            return true
        })
        .catchErrorJustReturn(false)
    }
}







