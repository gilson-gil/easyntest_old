//
//  AppDelegate.swift
//  Easyintest
//
//  Created by Gilson Gil on 16/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    let navigationController = UINavigationController(rootViewController: InvestmentViewController())
    navigationController.navigationBar.barTintColor = UIColor.white
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    return true
  }
}
