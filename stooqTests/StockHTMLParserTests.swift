//
//  StockHTMLParserTests.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 20.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import XCTest
@testable import stooq

class StockHTMLParserTests: XCTestCase {
    var parser: StockHTMLParser?
    
    override func setUp() {
        super.setUp()
        
        self.parser = StockHTMLParser()
    }

    func testParsingWebsiteWithSuccess() {
        guard let url = URL(string: "https://stooq.pl") else { return }
        
        let networkingManager = MockNetworkingManager()
        
        networkingManager.requestWebsite(from: url, success: { html in
            self.parser?.parse(html: html, success: { stocksArray in
                XCTAssert(stocksArray.count > 0, "Parser didn't parse valid website")
            }, failure: {
                XCTAssert(false, "Failure shouldn't be called")
            })
        }, failure: {})
    }
    
    func testParsingWebsiteWithFailure() {
        guard let url = URL(string: "https://stooq.pl") else { return }
        
        let networkingManager = MockNetworkingManager()
        networkingManager.shouldPassNormalTextInsteadOfHTML = true
        
        networkingManager.requestWebsite(from: url, success: { html in
            self.parser?.parse(html: html, success: { stocksArray in
                XCTAssert(false, "Success shouldn't be called")
            }, failure: {
                XCTAssert(true)
            })
        }, failure: {})
    }
}
