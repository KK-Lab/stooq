//
//  StockListViewModel.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 17.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import Foundation
import Kanna

class StockListViewModel {
    fileprivate var updateDate: Date?
    fileprivate let timer: TimerProtocol
    fileprivate let networkingManager: NetworkingManagerProtocol
    fileprivate let htmlParser: HTMLParserProtocol
    
    fileprivate var updateTimeInterval: TimeInterval = 30.0
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        return dateFormatter
    }()
   
    let stocksObservable: Observable<[Stock]>
    let errorObservable: Observable<Bool>
    
    var updateTimeString: String? {
        var updateTimeString: String? = nil
        
        if let updateDate = self.updateDate {
            updateTimeString = self.dateFormatter.string(from: updateDate)
        }
        
        return updateTimeString
    }
    
    convenience init() {
        self.init(networkingManager: StockNetworkingManager(), htmlParser: StockHTMLParser(), timer: StockTimer())
    }
    
    init(networkingManager: NetworkingManagerProtocol, htmlParser: HTMLParserProtocol, timer: TimerProtocol) {
        self.stocksObservable = Observable([])
        self.errorObservable = Observable(false)
        
        self.networkingManager = networkingManager
        self.htmlParser = htmlParser
        self.timer = timer
        self.timer.attachCompletion { [weak self] in self?.fetchStocks() }
    }
    
    func fetchStocksAndStartTimer() {
        self.fetchStocks()
        self.startTimer()
    }
    
    func startTimer() {
        self.timer.start(withTimeInterval: self.updateTimeInterval)
    }
    
    func stopTimer() {
        self.timer.stop()
    }
    
    func changeUpdateTimeInterval(to updateTimeInterval: TimeInterval) {
        self.stopTimer()
        self.updateTimeInterval = updateTimeInterval
        self.startTimer()
    }
}

fileprivate extension StockListViewModel {
    
    func fetchStocks() {
        guard let url = URL(string: "https://stooq.pl") else { return }

        let failure: () -> Void = { [weak self] in self?.errorObservable.value = true }
        
        self.networkingManager.requestWebsite(from: url, success: { [weak self] html in
            self?.htmlParser.parse(html: html, success: { [weak self] stocksArray in
                let stocks = Stock.stocks(fromArray: stocksArray, supportedStocks: SupportedStock.all)
                self?.updateStocks(stocks: stocks)
            }, failure: failure)
        }, failure: failure)
    }
    
    func updateStocks(stocks: [Stock]) {
        self.stocksObservable.value.forEach { $0.savePreviousValue() }
        self.updateDate = Date()
        self.stocksObservable.value = stocks
    }
}
