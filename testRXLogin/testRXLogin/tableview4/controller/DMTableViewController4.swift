//
//  DMTableViewController4.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/27.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class DMTableViewController4: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        automaticallyAdjustsScrollViewInsets = false
        let _ = tableview.rx.setDataSource(self)
        let _ = tableview.rx.setDelegate(self)
        tableview.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = String.init(indexPath.row)
        return cell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DMAlert.showAlert(on: view, message: String.init(indexPath.row))
        
    }
    

}
