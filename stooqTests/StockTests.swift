//
//  StockTests.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 20.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import XCTest
@testable import stooq

class StockTests: XCTestCase {
    var stocksArray: [[String]]!
    
    override func setUp() {
        super.setUp()
        
        self.stocksArray = MockHTMLParser().stocksArray
    }

    func testCreatingStocksFromArrayForAllSupportedStocks() {
        let supportedStocks: [SupportedStock] = SupportedStock.all
        let stocks = Stock.stocks(fromArray: self.stocksArray, supportedStocks: supportedStocks)
        
        XCTAssert(stocks.count == supportedStocks.count)
    }
    
    func testCreatingWIGStockFromArray() {
        let supportedStocks: [SupportedStock] = [SupportedStock.wig]
        let stocks = Stock.stocks(fromArray: self.stocksArray, supportedStocks: supportedStocks)
        let wigStock = stocks.first
        
        XCTAssert(stocks.count == supportedStocks.count)
        XCTAssertNotNil(wigStock)
        XCTAssertEqual(wigStock!.name, SupportedStock.wig.rawValue)
    }
    
    func testCreatingWIG20StockFromArray() {
        let supportedStocks: [SupportedStock] = [SupportedStock.wig20]
        let stocks = Stock.stocks(fromArray: self.stocksArray, supportedStocks: supportedStocks)
        let wig20Stock = stocks.first
        
        XCTAssert(stocks.count == supportedStocks.count)
        XCTAssertNotNil(wig20Stock)
        XCTAssertEqual(wig20Stock!.name, SupportedStock.wig20.rawValue)
    }
    
    func testCreatingMWIG40StockFromArray() {
        let supportedStocks: [SupportedStock] = [SupportedStock.mWIG40]
        let stocks = Stock.stocks(fromArray: self.stocksArray, supportedStocks: supportedStocks)
        let mWIG40Stock = stocks.first
        
        XCTAssert(stocks.count == supportedStocks.count)
        XCTAssertNotNil(mWIG40Stock)
        XCTAssertEqual(mWIG40Stock!.name, SupportedStock.mWIG40.rawValue)
    }
    
    func testCreatingSWIG80StockFromArray() {
        let supportedStocks: [SupportedStock] = [SupportedStock.sWIG80]
        let stocks = Stock.stocks(fromArray: self.stocksArray, supportedStocks: supportedStocks)
        let sWIG80Stock = stocks.first
        
        XCTAssert(stocks.count == supportedStocks.count)
        XCTAssertNotNil(sWIG80Stock)
        XCTAssertEqual(sWIG80Stock!.name, SupportedStock.sWIG80.rawValue)
    }
}
