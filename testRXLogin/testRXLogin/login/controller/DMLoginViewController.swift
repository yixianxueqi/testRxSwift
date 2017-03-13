//
//  DMLoginViewController.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/7.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DMLoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userNameValidLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordValidLabel: UILabel!
    @IBOutlet weak var repeatPwdTextField: UITextField!
    @IBOutlet weak var repeatPwdValidLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var siginIndicator: UIActivityIndicatorView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let viewModel = DMLoginViewModel.init(input: (userName: userNameTextField.rx.text.orEmpty.asDriver(),
                                                      pwd: passwordTextField.rx.text.orEmpty.asDriver(),
                                                      repeatPwd: repeatPwdTextField.rx.text.orEmpty.asDriver(),
                                                      loginTaps: signUpButton.rx.tap.asDriver()),
                                              dependency: (validService: DMLoginValidationService.validService,
                                                           httpService: DMLoginHttpServiceImp.httpService))
        
        viewModel.validateUserName
            .drive(userNameValidLabel.rx.validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.validatePwd
            .drive(passwordValidLabel.rx.validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.validateRepeatPwd
            .drive(repeatPwdValidLabel.rx.validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.signBtnEnable.drive(onNext: { [weak self] in
            self?.signUpButton.isEnabled = $0
            self?.signUpButton.alpha = $0 ? 1.0: 0.5
        }).addDisposableTo(disposeBag)
        
        viewModel.signed
            .throttle(0.5)
            .drive(onNext: { [weak self] in
            print("signUp success \($0)")
            self?.alert()
        }).addDisposableTo(disposeBag)
    }
    
    func alert() -> Void {
        let alert = UIAlertController.init(title: "注册", message: "注册并登陆成功", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "知道了", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}










