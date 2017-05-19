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
    
    @IBOutlet fileprivate weak var stockNameLabel: UILabel!
    @IBOutlet fileprivate weak var stockValueLabel: UILabel!
    @IBOutlet fileprivate weak var stockChangeInPercentageLabel: UILabel!
    @IBOutlet fileprivate weak var stockChangeInPercentageBackgroundView: UIView!
    
    var stock: Stock? {
        didSet {
            guard let stock = stock else { return }
            self.stockNameLabel?.text = stock.name
            self.stockValueLabel?.text = String(stock.value)
            self.stockChangeInPercentageLabel?.text = stock.changeInPercentage
            
            let changeInPercentageBackgroundColor: UIColor
            
            if stock.changeInPercentage.contains("-") {
                changeInPercentageBackgroundColor = UIColor.red
            }
            else if stock.changeInPercentage.contains("+") {
                changeInPercentageBackgroundColor = UIColor.green
            }
            else {
                changeInPercentageBackgroundColor = UIColor.gray
            }
            
            self.stockChangeInPercentageBackgroundView.backgroundColor = changeInPercentageBackgroundColor
            self.stockChangeInPercentageBackgroundView.layer.cornerRadius = 3
        }
    }
}

extension StockListCell: TableViewCellProtocol {
    
    class var height: CGFloat {
        return 50
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class func register(for tableView: UITableView) {
        tableView.register(UINib(nibName: self.identifier, bundle: Bundle.main), forCellReuseIdentifier: self.identifier)
    
    }
}
