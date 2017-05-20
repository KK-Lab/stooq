//
//  MockHTMLParser.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 20.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import Foundation
@testable import stooq

class MockHTMLParser: HTMLParserProtocol {
    var shouldParseWithSuccess: Bool = true
    var didParseWithSuccess: Bool = false
    
    let stocksArray: [[String]] = [
        ["WIG", "60739.95", "+1.40%", " ", "05-19"],
        ["WIG20", "2328.70", "+1.46%", "", "05-19"],
        ["WIG20 Fut", "2324", "+1.04%", "", "05-19"],
        ["WIG20USD", "620.22", "+2.44%", "", "05-19"],
        ["mWIG40", "4788.56", "+1.42%", "", "05-19"],
        ["sWIG80", "16127.08", "+1.25%", "", "05-19"],
        [""],
        ["S&P500", "2381.73", "+0.68%", "", "05-19"], 
        ["Nasdaq", "6083.70", "+0.47%", "", "05-19"], 
        ["EUR/PLN", "4.19387", "-0.57%", "", "05-19"], 
        ["USD/PLN", "3.74324", "-1.50%", "", "05-19"], 
        ["EUR/USD", "1.12039", "+0.94%", "", "05-19"], 
        ["Ropa WTI", "50.48", "+2.31%", "", "05-19"]]
    
    func parse(html: String, success: @escaping ([[String]]) -> Void, failure: @escaping () -> Void) {
        if self.shouldParseWithSuccess {
            self.didParseWithSuccess = true
            success(self.stocksArray)
        }
        else {
            failure()
        }
    }
}
