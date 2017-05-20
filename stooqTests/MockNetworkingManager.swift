//
//  MockNetworkingManager.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 20.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import Foundation
@testable import stooq

class MockNetworkingManager: NetworkingManagerProtocol {
    fileprivate let path = Bundle(for: StockHTMLParserTests.self).path(forResource: "website", ofType: "html")
    fileprivate let normalText: String = "blabla bldasf sdiaf sjdiofas j"
    
    var requestWebsiteWithSuccess: Bool = true
    var shouldPassNormalTextInsteadOfHTML: Bool = false
    var didRequestWebsiteWithSuccess: Bool = false
    
    func requestWebsite(from url: URL, success: @escaping (String) -> Void, failure: @escaping () -> Void) {
        if self.requestWebsiteWithSuccess {
            if self.shouldPassNormalTextInsteadOfHTML {
                success(self.normalText)
            }
            else {
                guard let path = self.path, let html = try? String(contentsOfFile: path) else { return }
                self.didRequestWebsiteWithSuccess = true
                success(html)
            }
        }
        else {
            failure()
        }
    }
}
