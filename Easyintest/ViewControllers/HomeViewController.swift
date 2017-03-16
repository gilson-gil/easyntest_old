//
//  HomeViewController.swift
//  Easyintest
//
//  Created by Gilson Gil on 16/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

final class HomeViewController: UIViewController {
  fileprivate let tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = UIColor.white
    tableView.separatorStyle = .none
    tableView.estimatedRowHeight = 44
    tableView.rowHeight = UITableViewAutomaticDimension
    return tableView
  }()
  
  fileprivate var homeViewModel: HomeViewModel? {
    didSet {
      self.tableView.register(self.homeViewModel?.configurators ?? [])
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setUp()
  }
  
  private func setUp() {
    view.addSubview(tableView)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    constrain(tableView) { tableView in
      tableView.top == tableView.superview!.top
      tableView.left == tableView.superview!.left
      tableView.bottom == tableView.superview!.bottom
      tableView.right == tableView.superview!.right
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    DispatchQueue.global().async { [weak self] in
      self?.homeViewModel = HomeViewModel()
    }
  }
}

// MARK: - UITableView DataSource
extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return homeViewModel?.configurators.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let homeViewModel = homeViewModel else {
      return UITableViewCell()
    }
    let configurator = homeViewModel.configurators[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: configurator.reuseIdentifier, for: indexPath)
    configurator.update(cell)
    return cell
  }
}

// MARK: - UITableView Delegate
extension HomeViewController: UITableViewDelegate {
  
}
