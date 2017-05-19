//
//  SupportedStock.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 18.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import Foundation

enum SupportedStock: String {
    case wig = "WIG"
    case wig20 = "WIG20"
    case mWIG40
    case sWIG80
    
    static var all: [SupportedStock] {
        return [.wig, .wig20, .mWIG40, .sWIG80]
    }
    
    var htmlComponentId: String {
        let htmlComponentId: String
        
        switch self {
        case .wig:
            htmlComponentId = "aq_wig_c2"
        case .wig20:
            htmlComponentId = "aq_wig20_c2"
        case .mWIG40:
            htmlComponentId = "aq_mwig40_c2"
        case .sWIG80:
            htmlComponentId = "aq_swig80_c2"
        }
        
        return htmlComponentId
    }
    
    var previousValue: Double? {
        set {
            UserDefaults.standard.set(newValue, forKey: self.rawValue)
            UserDefaults.standard.synchronize()
        }
        get {
            let previousValue = UserDefaults.standard.value(forKey: self.rawValue) as? Double
            return previousValue
        }
    }
    
    static func validate(value: String, withSupportedStocks supportedStocks: [SupportedStock]) -> Bool {
        var isValid: Bool = false
        
        supportedStocks.forEach {
            if value == $0.rawValue {
                isValid = true
                return
            }
        }
        
        return isValid
    }
}
