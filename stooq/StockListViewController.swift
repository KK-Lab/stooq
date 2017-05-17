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
    fileprivate var updatedTime: Date?
    
    var viewModel: StockListViewModel? {
        didSet {
            viewModel?.stocksObservable.bind { stocks in
                self.stocks = stocks
                self.updatedTime = Date()
                
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel?.startTimer()
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
        cell.stock = self.stocks[indexPath.row]
        
        return cell
    }
}

fileprivate extension StockListViewController {
    
    func setupTableView() {
        StockListCell.register(for: self.tableView)
    }
}
