//
//  InvestmentViewController.swift
//  Easyintest
//
//  Created by Gilson Gil on 20/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

final class InvestmentViewController: UIViewController {
  fileprivate let tableView: UITableView = {
    let tableView = UITableView()
    tableView.separatorStyle = .none
    tableView.estimatedRowHeight = 44
    tableView.rowHeight = UITableViewAutomaticDimension
    return tableView
  }()
  
  fileprivate var investmentViewModel = InvestmentViewModel()
  
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
    
    constrain(tableView) { tableView in
      tableView.top == tableView.superview!.top
      tableView.left == tableView.superview!.left
      tableView.bottom == tableView.superview!.bottom
      tableView.right == tableView.superview!.right
    }
    
    tableView.register(investmentViewModel?.configurators ?? [])
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.title = "Investimento"
    let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    navigationItem.rightBarButtonItems = [shareItem]
  }
}

// MARK: - Actions
extension InvestmentViewController {
  func shareTapped() {
    
  }
}

// MARK: - UITableView DataSource
extension InvestmentViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return investmentViewModel?.configurators.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let investmentViewModel = investmentViewModel else {
      return UITableViewCell()
    }
    let configurator = investmentViewModel.configurators[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: configurator.reuseIdentifier, for: indexPath)
    configurator.update(cell)
    return cell
  }
}

// MARK: UITableView Delegate
extension InvestmentViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let selectionCell = tableView.cellForRow(at: indexPath) as? SelectionProtocol else {
      return
    }
    selectionCell.wasSelected()
  }
}
