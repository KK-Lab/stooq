//
//  StockNetworkingManager.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 20.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import Foundation

protocol NetworkingManagerProtocol {
    func requestWebsite(from url: URL, success: @escaping (String) -> Void, failure: @escaping () -> Void)
}

class StockNetworkingManager: NetworkingManagerProtocol {
    
    func requestWebsite(from url: URL, success: @escaping (String) -> Void, failure: @escaping () -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            DispatchQueue.main.async {
                if error != nil {
                    failure()
                }
                else if let data = data, let html = String(data: data, encoding: .utf8) {
                    success(html)
                }
            }
        })
        
        task.resume()
    }
}
