//
//  Stock.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 17.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import Foundation

struct Stock {
    let name: String
    let value: Double
    let changeInPercentage: String
}

extension Stock {
    
    static func stocks(fromArray array: [[String]], supportedStocks: [SupportedStock]) -> [Stock] {
        let stocksArray = array.filter { $0.count >= 3 && SupportedStock.validate(value: $0[0], withSupportedStocks: supportedStocks) }
        
        return stocksArray.map { Stock(name: $0[0], value: Double($0[1]) ?? 0.0, changeInPercentage: $0[2]) }
    }
}
