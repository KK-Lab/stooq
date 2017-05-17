//
//  StockListCell.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 17.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewCellProtocol: class {
    static var height: CGFloat { get }
    static var identifier: String { get }
    
    static func register(for: UITableView)
}

class StockListCell: UITableViewCell {
    var stock: Stock? {
        didSet {
            self.textLabel?.text = stock?.name
        }
    }
}

extension StockListCell: TableViewCellProtocol {
    
    class var height: CGFloat {
        return 40
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class func register(for tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: identifier)
    }
}
