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
        
        automaticallyAdjustsScrollViewInsets = false
        items
            .bindTo(tableview.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .addDisposableTo(disposeBag)
        
        tableview.rx
            .modelSelected(String.self)
            .subscribe {
                print("click: \($0)");
                DMAlert.showAlert(on: self.view, message: String.init(describing: $0))
            }
            .addDisposableTo(disposeBag)
        
        tableview.rx
        .itemAccessoryButtonTapped
        .subscribe {
            print("taped: \($0)")
            DMAlert.showAlert(on: self.view, message: String.init(describing: $0))
        }
        .addDisposableTo(disposeBag)
        
    }
}



