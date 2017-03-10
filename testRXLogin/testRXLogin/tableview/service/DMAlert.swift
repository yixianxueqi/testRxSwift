//
//  DMAlert.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/10.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import MBProgressHUD

class DMAlert {

    static func showAlert(on view: UIView ,message: String) -> Void {
    
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.mode = .text
            hud.label.text = message
            hud.bezelView.color = UIColor.black
            hud.label.textColor = UIColor.white
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: { 
                hud.hide(animated: true)
            })
        }
        
        
    }
}
