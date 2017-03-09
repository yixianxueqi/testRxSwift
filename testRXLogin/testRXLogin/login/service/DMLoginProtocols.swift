//
//  DMLoginProtocols.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/7.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import RxSwift

protocol DMLoginValidService {
    
    func validationUserName(_ usernName: String) -> Observable<ValidationResult>
    func validationPassword(_ password: String) -> ValidationResult
    func validationRepeatPwd(_ pwd: String, repeatPwd: String) -> ValidationResult
    
}

protocol DMLoginHttpService {
    
    func checkUserNameAvaliable(userName: String) -> Observable<Bool>
    func signUp(userName: String, pwd: String) -> Observable<Bool>
    
}
