//
//  UISegmentedControl+Segment.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 20.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {
    
    enum Segment: String {
        case first = "10 sec"
        case second = "20 sec"
        case third = "30 sec"
        
        static var all: [Segment] {
            return [.first, .second, .third]
        }
        
        var index: Int {
            let index: Int
            
            switch self {
            case .first:
                index = 0
            case .second:
                index = 1
            case .third:
                index = 2
            }
            
            return index
        }
        
        var value: Double {
            let value: Double
            
            switch self {
            case .first:
                value = 10.0
            case .second:
                value = 20.0
            case .third:
                value = 30.0
            }
            
            return value
        }
        
        init?(index: Int) {
            switch index {
            case 0:
                self = .first
            case 1:
                self = .second
            case 2:
                self = .third
            default:
                return nil
            }
        }
    }
    
    convenience init(segments: [Segment]) {
        let items = segments.map { $0.rawValue }
        self.init(items: items)
    }
}
