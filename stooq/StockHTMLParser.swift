//
//  StockHTMLParser.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 20.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import Foundation
import Kanna

protocol HTMLParserProtocol {
    func parse(html: String, success: @escaping ([[String]]) -> Void, failure: @escaping () -> Void)
}

class StockHTMLParser: HTMLParserProtocol {
    
    func parse(html: String, success: @escaping ([[String]]) -> Void, failure: @escaping () -> Void) {
        guard let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) else {
            failure()
            return
        }
        
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
        
        guard let stocksArray = tbody.first?.css("tr").map({ $0.css("td").flatMap { $0.content } }) else {
            failure()
            return
        }
        
        success(stocksArray)
    }
}
