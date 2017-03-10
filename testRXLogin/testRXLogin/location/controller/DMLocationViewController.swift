//
//  DMLocationViewController.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/10.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import CoreLocation

private extension Reactive where Base: UILabel {
    var coordinates: UIBindingObserver<Base, CLLocationCoordinate2D> {
        return UIBindingObserver(UIElement: base) { label, location in
            label.text = "Lat: \(location.latitude)\nLon: \(location.longitude)"
        }
    }
}

class DMLocationViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var changeSettings1: UIButton!
    @IBOutlet weak var changeSettings2: UIButton!
    @IBOutlet var notEnableView: UIView!
    let disposeBag = DisposeBag()
    let locationService = DMLocationService.locationService
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(notEnableView)
        locationService.authorized
            .drive(self.notEnableView.rx.isHidden)
            .addDisposableTo(disposeBag)
     
        locationService.location
            .drive(self.label.rx.coordinates)
            .addDisposableTo(disposeBag)
        
        changeSettings1.rx.tap
            .bindNext { [weak self] in
                self?.openSettings()
            }
            .addDisposableTo(disposeBag)
        
        changeSettings2.rx.tap
            .bindNext { [weak self] in
                self?.openSettings()
            }
            .addDisposableTo(disposeBag)
        
    }
    
    private func openSettings() -> Void {
    
        UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    }
}
