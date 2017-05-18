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
    let stocksObservable: Observable<[Stock]>
    
    fileprivate var timer: Timer?
    
    init() {
        self.stocksObservable = Observable([])
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
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
                        self.stocksObservable.value = Stock.stocks(fromArray: stocksArray, supportedStocks: SupportedStock.all)
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
}
