//
//  DMCache.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/13.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import SwiftyJSON

enum DMCacheType {
    
    //仅使用请求数据
    case onlyRequest
    //先使用本地缓存数据，再请求新数据
    case cacheThenRequest
    //仅使用缓存数据
    case onlyCache
}

//该类仅仅只是个示范
class DMCache {

    static let cache = DMCache()
    private var store: [String: Any?] = [:]
    private init () {}
    
    func storeValue(_ value: Response, forKey: String) -> Void {
    
        store.updateValue(value, forKey: forKey)
    }
    
    func getValue(forKey: String) -> Response? {
        
        return store[forKey] as? Response ?? nil
    }
}

extension RxMoyaProvider {

    func tryCache(target: Target, cacheType: DMCacheType) -> Observable<Moya.Response> {
        
        let identifier = getIdentifier(target: target)
        let cache = DMCache.cache
        var task: Cancellable?
        return Observable.create({[weak self, weak cache]  observe -> Disposable in
            
            switch cacheType {
            case .onlyCache:
                print("使用缓存！！！")
                if let response = cache?.getValue(forKey: identifier) {
                    observe.onNext(response)
                }
                observe.onCompleted()
            case .cacheThenRequest:
                print("先使用缓存再请求数据！！！")
                if let response = cache?.getValue(forKey: identifier) {
                    observe.onNext(response)
                }
                fallthrough
            case .onlyRequest:
                print("请求数据！！！")
                task = self?.request(target) { result in
                    switch result {
                    case let .success(response):
                        observe.onNext(response)
                        observe.onCompleted()
                        cache?.storeValue(response, forKey: identifier)
                    case let .failure(error):
                        observe.onError(error)
                    }
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        })
    }
    //获取该请求的唯一标示，ulr + parameter
    func getIdentifier(target: Target) -> String {
        
        let paraStr = JSON(target.parameters as Any).string ?? ""
        let identifier = target.baseURL.absoluteString + target.path + paraStr
        return identifier
    }
}





