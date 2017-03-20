//
//  TabViewController.swift
//  Easyintest
//
//  Created by Gilson Gil on 20/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

final class TabViewController: UIViewController {
  fileprivate let containerView: UIView = {
    let view = UIView()
    return view
  }()
  
  fileprivate let investmentButton: TabItem = {
    let button = TabItem(title: "Investimento")
    button.isSelected = true
    return button
  }()
  
  fileprivate let contactButton: TabItem = {
    let button = TabItem(title: "Contato")
    return button
  }()
  
  fileprivate lazy var investmentViewController = InvestmentViewController()
  fileprivate lazy var contactViewController = ContactViewController()
  fileprivate var navController: UINavigationController!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setUp()
    navController = UINavigationController(rootViewController: investmentViewController)
    navController.navigationBar.barTintColor = UIColor.white
    navController.willMove(toParentViewController: self)
    navController.view.frame = containerView.bounds
    containerView.addSubview(navController.view)
    addChildViewController(navController)
    navController.didMove(toParentViewController: self)
  }
  
  private func setUp() {
    view.addSubview(containerView)
    view.addSubview(investmentButton)
    view.addSubview(contactButton)
    
    constrain(containerView, investmentButton, contactButton) { containerView, investmentButton, contactButton in
      containerView.top == containerView.superview!.top
      containerView.left == containerView.superview!.left
      containerView.right == containerView.superview!.right
      
      investmentButton.top == containerView.bottom
      investmentButton.left == investmentButton.superview!.left
      investmentButton.bottom == investmentButton.superview!.bottom
      
      contactButton.top == investmentButton.top
      contactButton.left == investmentButton.right
      contactButton.bottom == contactButton.superview!.bottom
      contactButton.right == contactButton.superview!.right
      
      investmentButton.width == contactButton.width
    }
    
    investmentButton.addTarget(self, action: #selector(investmentsTapped), for: .touchUpInside)
    contactButton.addTarget(self, action: #selector(contactTapped), for: .touchUpInside)
  }
}

// MARK: - Actions
extension TabViewController {
  func investmentsTapped() {
    guard !investmentButton.isSelected else {
      return
    }
    investmentButton.isSelected = true
    contactButton.isSelected = false
    present(investmentViewController)
  }
  
  func contactTapped() {
    guard !contactButton.isSelected else {
      return
    }
    investmentButton.isSelected = false
    contactButton.isSelected = true
    present(contactViewController)
  }
}

// MARK: - Private
fileprivate extension TabViewController {
  func present(_ viewController: UIViewController) {
    navController.viewControllers = [viewController]
  }
}
