//
//  MockTimer.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 20.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import Foundation
@testable import stooq

class MockTimer: TimerProtocol {
    fileprivate let timeInterval: TimeInterval
    fileprivate var completion: (() -> Void)?
    
    var didCallStart: Bool = false
    var didCallStop: Bool = false
    var didCallCompletion: Bool = false
    
    required init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    func attachCompletion(completion: @escaping () -> Void) {
        self.completion = {
            self.didCallCompletion = true
            completion()
        }
    }
    
    func start() {
        self.didCallStart = true
        self.completion?()
    }
    
    func stop() {
        self.didCallStop = true
    }
}
