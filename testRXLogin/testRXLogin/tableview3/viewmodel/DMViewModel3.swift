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

//刷新状态枚举
enum DMRefresh {
    //下拉刷新
    case refreshHeader
    //上拉加载更多
    case refreshFooter
    //上拉加载更多&&无更多数据
    case refreshFooterNoMoreData
    //闲置状态
    case refreshWait
}

class DMViewModel3: NSObject {
    
    var tableView: UITableView?
    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>>?
    //刷新状态
    var refreshStatus: Variable<DMRefresh>?
    //原始数据源
    var dataList: [String] = []
    let disposeBag = DisposeBag()
    
    
    /// 配置viewModel
    ///
    /// - Parameters:
    ///   - tableView: 接收controller的tableview
    ///   - dataSource: 接受模型类型
    func prepare(tableView: UITableView, dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>>) -> Void {
        
        self.tableView = tableView
        self.dataSource = dataSource
        refreshStatus = Variable(DMRefresh.refreshWait)
    }
    
    //刷新数据
    func refreshData() -> Void {
        
        dataList.removeAll()
        dataList.append(contentsOf: DMService3.getDataList(page: 0))
        getDatas(list: dataList)
        //重设刷新状态
        refreshStatus?.value = .refreshHeader
    }
    
    //加载更多
    func refreshMoreData() -> Void {
        
        let page = dataList.count / pageSize
        let list = DMService3.getDataList(page: page)
        dataList.append(contentsOf: list)
        getDatas(list: dataList)
        //重设刷新状态
        if list.count < pageSize {
            refreshStatus?.value = .refreshFooterNoMoreData
        } else {
            refreshStatus?.value = .refreshFooter
        }
    }
    
    
    /// 重新绑定数据源
    ///
    /// - Parameter list: 原始数据
    private func getDatas(list: [String]) -> Void {
        
        self.tableView?.dataSource = nil
        Observable.create({ (observe) -> Disposable in
            
            let section = [SectionModel.init(model: "", items: list)]
            observe.onNext(section)
            observe.onCompleted()
            return Disposables.create()
        })
            .bindTo(self.tableView!.rx.items(dataSource: self.dataSource!))
            .addDisposableTo(disposeBag)
    }
}





