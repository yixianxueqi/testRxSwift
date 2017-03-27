//
//  DMTableViewController3.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/22.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh
import RxDataSources

class DMTableViewController3: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    let viewModel = DMViewModel3()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        automaticallyAdjustsScrollViewInsets = false
        //配置viewModel
        viewModel.prepare(tableView: tableview, dataSource: dataSource)
        //配置tableview
        deployTableView()
        //添加观察者
        addObserve()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableview.mj_header.beginRefreshing()
    }
    
    // MARK: - private
    /// 配置tableview
    /// 添加上下拉刷新 ，注册cell, 设置cell显示模型
    private func deployTableView() -> Void {
        
        addRefresh()
        tableview.register(UINib.init(nibName: "DMTableViewCell3", bundle: nil), forCellReuseIdentifier: "cell")
        dataSource.configureCell = { _, tableview, indexPath, str in
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DMTableViewCell3
            cell.setModel(str)
            cell.cellBlock = {[weak self] observe in
                observe.asDriver(onErrorJustReturn: "cell click error")
                    .filter({ str -> Bool in
                        return str.characters.count > 0 ? true: false
                    })
                    .drive(onNext: { (str) in
                        DMAlert.showAlert(on: self!.view, message: str)
                    }, onCompleted: {
                        print("cell complete")
                    }).addDisposableTo(DisposeBag())
            }
            return cell
        }
    }
    
    //添加viewModel的dataList观察
    //note: swift中观察者较麻烦，要满足以下条件：
    //      1.必须是NSObject的子类
    //      2.属性前要添加dynamic关键字
    func addObserve() -> Void {
        
        viewModel.rx.observe([String].self, "dataList")
        .subscribe(onNext: {
            print($0!.count)
        }).addDisposableTo(viewModel.disposeBag)
    
    }

    /// 设置tableview的刷新
    /// 添加上下拉刷新，订阅刷新状态的变化
    private func addRefresh() -> Void {
        
        tableview.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(refreshData))
        tableview.mj_footer = MJRefreshBackStateFooter.init(refreshingTarget: self, refreshingAction: #selector(refreshMoreData))
        
        viewModel.refreshStatus?.asDriver().drive(onNext: {[weak self] status in
            switch status {
            case .refreshHeader:
                self?.tableview.mj_header.endRefreshing()
                self?.tableview.mj_footer.resetNoMoreData()
            case .refreshFooter:
                self?.tableview.mj_footer.endRefreshing()
            case .refreshFooterNoMoreData:
                self?.tableview.mj_footer.endRefreshingWithNoMoreData()
            default:
                self?.tableview.mj_header.endRefreshing()
                self?.tableview.mj_footer.endRefreshing()
            }
        }).addDisposableTo(viewModel.disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(10)) {
            self.tableview.mj_header.endRefreshing()
        }
    }
    
    @objc private func refreshData() -> Void {
        
        viewModel.refreshData()
    }
    
    @objc private func refreshMoreData() -> Void {
        
        viewModel.refreshMoreData()
    }
    
}











