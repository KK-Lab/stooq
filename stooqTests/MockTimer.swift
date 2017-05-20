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
    fileprivate var completion: (() -> Void)?
    fileprivate(set) var timeInterval: TimeInterval
    let defaultTimeInterval: TimeInterval = 30.0
    
    var didCallStart: Bool = false
    var didCallStop: Bool = false
    var didCallCompletion: Bool = false
    var didChangeTimeInterval: Bool = false
    
    init() {
        self.timeInterval = self.defaultTimeInterval
    }
    
    func attachCompletion(completion: @escaping () -> Void) {
        self.completion = {
            self.didCallCompletion = true
            completion()
        }
    }
    
    func start(withTimeInterval timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
        
        if timeInterval != self.defaultTimeInterval {
            self.didChangeTimeInterval = true
        }
        
        self.didCallStart = true
        self.completion?()
    }
    
    func stop() {
        self.didCallStop = true
    }
}
