//
//  DMTableViewCell3.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/22.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit

class DMTableViewCell3: UITableViewCell {

    
    @IBOutlet weak var defineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        print(#function)
    }
    
    func setModel(_ str: String) -> Void {
    
        defineLabel.text = str
    }
    
}
