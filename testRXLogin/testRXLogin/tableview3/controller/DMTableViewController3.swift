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
        viewModel.prepare(tableView: tableview, dataSource: dataSource)
        deployTableView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableview.mj_header.beginRefreshing()
    }
    
    func deployTableView() -> Void {
        
        addRefresh()
        tableview.register(UINib.init(nibName: "DMTableViewCell3", bundle: nil), forCellReuseIdentifier: "cell")
        dataSource.configureCell = { _, tableview, indexPath, str in
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DMTableViewCell3
            cell.setModel(str)
            return cell
        }
    }
    
    func addRefresh() -> Void {
        
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
    
    func refreshData() -> Void {
        
        viewModel.refreshData()
    }
    
    func refreshMoreData() -> Void {
        
        viewModel.refreshMoreData()
    }
    
}











