//
//  StockListViewController.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 17.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import Foundation
import UIKit

class StockListViewController: UITableViewController {
    fileprivate var stocks: [Stock] = []
    
    var viewModel: StockListViewModel? {
        didSet {
            viewModel?.stocksObservable.bind { [weak self] stocks in
                self?.stocks = stocks
                self?.tableView.reloadData()
            }
            viewModel?.errorObservable.bind({ [weak self] error in
                if error {
                    self?.viewModel?.stopTimer()
                    self?.showAlert()
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel?.fetchStocksAndStartTimer()
    }
}

extension StockListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stocks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StockListCell = tableView.dequeueReusableCell(withIdentifier: StockListCell.identifier, for: indexPath) as! StockListCell
        let stock: Stock = self.stocks[indexPath.row]
        cell.stock = stock
        
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let updateTime = self.viewModel?.updateTime else { return nil }
        
        let headerFrame = CGRect(x: 0, y: 5, width: UIScreen.main.bounds.width, height: 35)
        let view = UIView(frame: headerFrame)
        view.backgroundColor = UIColor.black
        
        let label = UILabel(frame: headerFrame)
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Updated at: " + updateTime
        
        view.addSubview(label)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.viewModel?.updateTime == nil ? 0 : 40
    }
}

fileprivate extension StockListViewController {
    
    func setupNavigationBar() {
        self.title = "stooq.pl"
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.italicSystemFont(ofSize: 23)
        ]
    }
    
    func setupTableView() {
        self.tableView.separatorColor = UIColor.darkGray
        self.tableView.backgroundColor = UIColor.black
        self.tableView.rowHeight = StockListCell.height
        
        StockListCell.register(for: self.tableView)
    }
    
    func showAlert() {
        // TODO: show alertVC and then self.viewModel?.fetchStocksAndStartTimer()
    }
}
