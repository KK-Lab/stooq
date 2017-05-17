//
//  StockListViewModel.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 17.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import Foundation

class StockListViewModel {
    let stocksObservable: Observable<[Stock]>
    
    init() {
        self.stocksObservable = Observable([])
    }
    
    func stopTimer() {
        
    }
    
    func startTimer() {
        
    }
}
