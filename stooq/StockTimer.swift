//
//  StockTimer.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 20.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import Foundation

protocol TimerProtocol {
    func attachCompletion(completion: @escaping () -> Void)
    func start(withTimeInterval: TimeInterval)
    func stop()
}

class StockTimer: TimerProtocol {
    fileprivate var timer: Timer?
    fileprivate var completion: (() -> Void)?
    
    func attachCompletion(completion: @escaping () -> Void) {
        self.completion = completion
    }
    
    func start(withTimeInterval timeInterval: TimeInterval) {
        self.timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            self?.completion?()
        }
    }
    
    func stop() {
        self.timer?.invalidate()
        self.timer = nil
    }
}
