//
//  MockStockListViewController.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 20.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import Foundation
@testable import stooq

class MockStockListViewController {
    var didGetStocks: Bool = false
    var didGetError: Bool = false
    var stocks: [Stock]?
    
    var viewModel: StockListViewModel? {
        didSet {
            viewModel?.stocksObservable.bind { stocks in
                self.didGetStocks = true
                self.stocks = stocks
            }
            
            viewModel?.errorObservable.bind {
                if $0 {
                    self.didGetError = true
                }
            }
        }
    }
}
