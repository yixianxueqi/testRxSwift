//
//  DMTableViewController.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/10.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DMTableViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    
    let disposeBag = DisposeBag()
    let items = Observable.just(
        (0...10).map { "\($0)" }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

    }

}
