//
//  DMViewModel3.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/22.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


enum DMRefresh {
    case refreshHeader
    case refreshFooter
    case refreshFooterNoMoreData
    case refreshWait
}

class DMViewModel3: NSObject {

    var tableView: UITableView?
    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>>?
    var refreshStatus: Variable<DMRefresh>?
    var dataList: [String] = []
    let disposeBag = DisposeBag()

    func prepare(tableView: UITableView, dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>>) -> Void {
    
        self.tableView = tableView
        self.dataSource = dataSource
        refreshStatus = Variable(DMRefresh.refreshWait)
    }
    
    func getDatas(list: [String]) -> Void {

        Observable.create({ (observe) -> Disposable in
            
            let section = [SectionModel.init(model: "", items: list)]
            observe.onNext(section)
            observe.onCompleted()
            return Disposables.create()
        })
        .bindTo(self.tableView!.rx.items(dataSource: self.dataSource!))
        .addDisposableTo(disposeBag)
    }
    
    //刷新数据
    func refreshData() -> Void {
    
        self.tableView?.dataSource = nil
        dataList.removeAll()
        dataList.append(contentsOf: DMService3.getDataList(page: 0))
        getDatas(list: dataList)
        refreshStatus?.value = .refreshHeader
    }
    
    //加载更多
    func refreshMoreData() -> Void {
    
        self.tableView?.dataSource = nil
        let page = dataList.count / pageSize
        dataList.append(contentsOf: DMService3.getDataList(page: page))
        getDatas(list: dataList)
        refreshStatus?.value = .refreshFooter
    }
}





