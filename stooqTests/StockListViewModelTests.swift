//
//  StockListViewModelTests.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 20.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import XCTest
@testable import stooq

class StockListViewModelTests: XCTestCase {
    var parser: MockHTMLParser!
    var networkingManager: MockNetworkingManager!
    var timer: MockTimer!
    var stockListViewModel: StockListViewModel!
    var stockListViewController: MockStockListViewController!
    
    override func setUp() {
        super.setUp()
        
        self.parser = MockHTMLParser()
        self.networkingManager = MockNetworkingManager()
        self.timer = MockTimer()
        
        self.stockListViewModel = StockListViewModel(networkingManager: networkingManager, htmlParser: parser, timer: timer)
        self.stockListViewController = MockStockListViewController()
        self.stockListViewController.viewModel = self.stockListViewModel
    }
    
    func testInitialSetup() {
        XCTAssertFalse(self.timer.didCallCompletion)
        XCTAssertFalse(self.timer.didCallStart)
        XCTAssertFalse(self.timer.didCallStop)
        XCTAssertFalse(self.timer.didChangeTimeInterval)
        XCTAssertEqual(self.timer.defaultTimeInterval, 30.0)
        
        XCTAssertFalse(self.networkingManager.didRequestWebsiteWithSuccess)
        
        XCTAssertFalse(self.parser.didParseWithSuccess)
        
        XCTAssertFalse(self.stockListViewController.didGetStocks)
        XCTAssertFalse(self.stockListViewController.didGetError)
        XCTAssertNil(self.stockListViewController.stocks)
    }

    func testStartingAndStoppingTimer() {
        self.stockListViewModel.startTimer()
        XCTAssert(self.timer.didCallStart)
        
        self.stockListViewModel.stopTimer()
        XCTAssert(self.timer.didCallStop)
    }
    
    func testFetchingStocksWithSuccess() {
        self.stockListViewModel.startTimer()
        
        XCTAssert(self.timer.didCallCompletion)
        XCTAssert(self.networkingManager.didRequestWebsiteWithSuccess)
        XCTAssert(self.parser.didParseWithSuccess)
        XCTAssert(self.stockListViewController.didGetStocks, "Didn't get stocks")
        XCTAssertNotNil(self.stockListViewController.stocks, "Stocks shouldn't be nil")
    }
    
    func testFetchingStocksWithNetworkingFailure() {
        self.networkingManager.requestWebsiteWithSuccess = false
        self.stockListViewModel.startTimer()
        
        XCTAssertFalse(self.networkingManager.didRequestWebsiteWithSuccess)
        XCTAssert(self.stockListViewController.didGetError)
    }
    
    func testFetchingStocksWithParsingFailure() {
        self.parser.shouldParseWithSuccess = false
        self.stockListViewModel.startTimer()
        
        XCTAssert(self.networkingManager.didRequestWebsiteWithSuccess)
        XCTAssertFalse(self.parser.didParseWithSuccess)
        XCTAssert(self.stockListViewController.didGetError)
    }
    
    func testChangingUpdateTimeIntervalToTenSeconds() {
        self.stockListViewController.changeSegmentedControlSegment(to: .first)
        
        XCTAssert(self.timer.didChangeTimeInterval)
        XCTAssertEqual(self.timer.timeInterval, UISegmentedControl.Segment.first.value)
    }
    
    func testChangingUpdateTimeIntervalToTwentySeconds() {
        self.stockListViewController.changeSegmentedControlSegment(to: .second)
        
        XCTAssert(self.timer.didChangeTimeInterval)
        XCTAssertEqual(self.timer.timeInterval, UISegmentedControl.Segment.second.value)
    }
}
