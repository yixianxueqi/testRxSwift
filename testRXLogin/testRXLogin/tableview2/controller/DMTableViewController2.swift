//
//  DMTableViewController2.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/15.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DMTableViewController2: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    let disposeBag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Double>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dataSource = self.dataSource
        let items = Observable.just([
            SectionModel(model: "First section", items: [
                1.0,
                2.0,
                3.0
                ]),
            SectionModel(model: "Second section", items: [
                1.0,
                2.0,
                3.0
                ]),
            SectionModel(model: "Third section", items: [
                1.0,
                2.0,
                3.0
                ])
            ])
        dataSource.configureCell = { list, tableview, indexPath, item in
        
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell")!
            cell.textLabel?.text = "\(item) @row \(indexPath.row)"
            return cell
        }
        
        items.bindTo(tableview.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        tableview.rx
            .itemSelected
            .map { indexPath in
                return (indexPath, dataSource[indexPath])
            }
            .subscribe(onNext: { indexPath, model in
                DMAlert.showAlert(on: self.view, message: "taped \(model) at \(indexPath)")
            })
            .addDisposableTo(disposeBag)
        
        tableview.rx
            .setDelegate(self)
            .addDisposableTo(disposeBag)
        
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect.zero)
        label.text = dataSource[section].model
        return label
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

}
