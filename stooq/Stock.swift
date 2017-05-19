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
    let previousValue: Double?
    let changeInPercentage: String
    
    var hasValueChanged: Bool {
        var hasValueChanged: Bool = false
        
        if let previousValue = self.previousValue {
            hasValueChanged = self.value != previousValue
        }
        
        return hasValueChanged
    }
}

extension Stock {
    
    static func stocks(fromArray array: [[String]], supportedStocks: [SupportedStock]) -> [Stock] {
        let stocksArray = array.filter { $0.count >= 3 && SupportedStock.validate(value: $0[0], withSupportedStocks: supportedStocks) }
        
        return stocksArray.map { Stock(name: $0[0], value: Double($0[1]) ?? 0.0, previousValue: SupportedStock(rawValue: $0[0])?.previousValue, changeInPercentage: $0[2]) }
    }
   
    func savePreviousValue() {
        var supportedStock = SupportedStock(rawValue: self.name)
        supportedStock?.previousValue = self.value
    }
}
