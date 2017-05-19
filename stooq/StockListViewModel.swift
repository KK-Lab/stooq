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
    fileprivate var timer: Timer?
    fileprivate let timeInterval: TimeInterval = 30.0
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        return dateFormatter
    }()
   
    let stocksObservable: Observable<[Stock]>
    
    var updateTime: String? {
        var updateTime: String? = nil
        
        if let updateDate = self.updateDate {
            updateTime = self.dateFormatter.string(from: updateDate)
        }
        
        return updateTime
    }
    
    init() {
        self.stocksObservable = Observable([])
    }
    
    func fetchStocksAndStartTimer() {
        self.fetchStocks()
        self.startTimer()
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: self.timeInterval, repeats: true) { [weak self] _ in
            self?.fetchStocks()
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
}

fileprivate extension StockListViewModel {
    
    func fetchStocks() {
        let url = URL(string: "https://stooq.pl")
        let request = URLRequest(url: url!)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let data = data, let html = String(data: data, encoding: .utf8) {
                self.parse(html: html, completion: { stocksArray in
                    DispatchQueue.main.async {
                        let stocks = Stock.stocks(fromArray: stocksArray, supportedStocks: SupportedStock.all)
                        self.updateStocks(stocks: stocks)
                    }
                })
            }
            // TODO: handle error
            
        })
        task.resume()
    }
    
    func parse(html: String, completion: ([[String]]) -> Void) {
        guard let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) else { return }
        
        let tbody = doc.css("tbody[id='f13']").filter {
            if let tbodyHTML = $0.toHTML {
                return
                    tbodyHTML.contains(SupportedStock.wig.htmlComponentId) &&
                    tbodyHTML.contains(SupportedStock.wig20.htmlComponentId) &&
                    tbodyHTML.contains(SupportedStock.mWIG40.htmlComponentId) &&
                    tbodyHTML.contains(SupportedStock.sWIG80.htmlComponentId)
            }
            else {
                return false
            }
            
        }
        guard let stocksArray = tbody.first?.css("tr").map({ $0.css("td").flatMap { $0.content } }) else { return }
        
        completion(stocksArray)
    }
    
    func updateStocks(stocks: [Stock]) {
        self.stocksObservable.value.forEach { $0.savePreviousValue() } // TODO: check it
        self.updateDate = Date()
        self.stocksObservable.value = stocks
    }
}
