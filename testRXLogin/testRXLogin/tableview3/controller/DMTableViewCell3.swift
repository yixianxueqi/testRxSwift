//
//  DMTableViewCell3.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/22.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias DMCellAction = (Observable<String>) -> Void

class DMTableViewCell3: UITableViewCell {

    @IBOutlet weak var defineLabel: UILabel!
    @IBOutlet weak var tapButton: UIButton!
    
    var cellBlock: DMCellAction?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        print(#function)
    }
    
    func setModel(_ str: String) -> Void {
    
        defineLabel.text = str
    }
    //按钮点击事件
    @IBAction func clickButton(_ sender: UIButton) {
        
        if let cellBlock = self.cellBlock {
            cellBlock(Observable.create({ (observe) -> Disposable in
                observe.onNext(self.defineLabel.text!)
                observe.onCompleted()
                return Disposables.create()
            }))
        }
    }
    
}
