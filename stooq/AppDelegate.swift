//
//  AppDelegate.swift
//  stooq
//
//  Created by Krzysztof Kaczmarek on 17.05.2017.
//  Copyright © 2017 KK-Lab. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    fileprivate var stockListViewModel: StockListViewModel?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let stockListViewController = StockListViewController()
        let stockListViewModel = StockListViewModel()
        stockListViewController.viewModel = stockListViewModel
        self.stockListViewModel = stockListViewModel
        
        let navigationController = UINavigationController(rootViewController: stockListViewController)
        
        let window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        self.stockListViewModel?.stopTimer()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.stockListViewModel?.startTimer()
    }
}

