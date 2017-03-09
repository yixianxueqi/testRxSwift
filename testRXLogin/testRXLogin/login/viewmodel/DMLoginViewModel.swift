//
//  DMLoginViewModel.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/7.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DMLoginViewModel {
    
    var validateUserName: Driver<ValidationResult>
    var validatePwd: Driver<ValidationResult>
    var validateRepeatPwd: Driver<ValidationResult>
    
    var signBtnEnable: Driver<Bool>
    var signed: Driver<Bool>
    //    var signing: Driver<Bool>
    
    init(input:(
            userName: Driver<String>,
            pwd: Driver<String>,
            repeatPwd: Driver<String>,
            loginTaps: Driver<Void>),
         dependency:(
            validService: DMLoginValidService,
            httpService:DMLoginHttpService)
        ) {
        
        let validService = dependency.validService
        let httpService = dependency.httpService
        
        validateUserName = input.userName.flatMapLatest {
            return validService.validationUserName($0)
                .asDriver(onErrorJustReturn: .failed(message: "链接服务失败"))
        }
        validatePwd = input.pwd.map {
            return validService.validationPassword($0)
        }
        validateRepeatPwd = Driver.combineLatest(input.pwd, input.repeatPwd, resultSelector: validService.validationRepeatPwd)
        
        signBtnEnable = Driver.combineLatest(validateUserName, validatePwd, validateRepeatPwd) {
            $0.isValid && $1.isValid && $2.isValid
            }.distinctUntilChanged()
        
        let usernameAndPwd = Driver.combineLatest(input.userName, input.pwd) { ($0, $1) }
//        signed = Driver.just(true)
        signed = input.loginTaps.withLatestFrom(usernameAndPwd)
        .flatMapLatest({
            return httpService.signUp(userName: $0, pwd: $1)
                .asDriver(onErrorJustReturn: false)
        })
    }
}
