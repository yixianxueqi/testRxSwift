//
//  DMLocationService.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/10.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

class DMLocationService {

    private (set) var authorized: Driver<Bool>
    private (set) var location: Driver<CLLocationCoordinate2D>
    private let locationManager = CLLocationManager()
    
    static let locationService = DMLocationService()
    private init() {
    
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        authorized = Observable.deferred({ [weak locationManager] in
            let status = CLLocationManager.authorizationStatus()
            guard let locationManager = locationManager else {
                return Observable.just(status)
            }
            return locationManager
                .rx.didChangeAuthorizationStatus
                .startWith(status)
        }).asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
        .map({ status in
            switch status {
            case .authorizedAlways:
                return true
            default:
                return false
            }
        })
     location = locationManager.rx.didUpdateLocations
        .asDriver(onErrorJustReturn: [])
        .flatMap({
            return $0.last.map(Driver.just) ?? Driver.empty()
        })
        .map {
            $0.coordinate
        }
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
}















