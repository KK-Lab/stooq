//
//  StockTimer.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 20.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import Foundation

protocol TimerProtocol {
    init(timeInterval: TimeInterval)
    func attachCompletion(completion: @escaping () -> Void)
    func start()
    func stop()
}

class StockTimer: TimerProtocol {
    fileprivate var timer: Timer?
    fileprivate var completion: (() -> Void)?
    fileprivate let timeInterval: TimeInterval
    
    required init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    func attachCompletion(completion: @escaping () -> Void) {
        self.completion = completion
    }
    
    func start() {
        self.timer = Timer.scheduledTimer(withTimeInterval: self.timeInterval, repeats: true) { [weak self] _ in
            self?.completion?()
        }
    }
    
    func stop() {
        self.timer?.invalidate()
        self.timer = nil
    }
}
