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
    tableView.keyboardDismissMode = .onDrag
    return tableView
  }()
  
  fileprivate var homeViewModel: HomeViewModel? {
    didSet {
      self.tableView.register(self.homeViewModel?.configurators ?? [])
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
    let keyboardHandlerViewController = KeyboardHandlerViewController(scrollView: tableView)
    keyboardHandlerViewController.willMove(toParentViewController: self)
    keyboardHandlerViewController.view.alpha = 0
    keyboardHandlerViewController.view.frame = .zero
    addChildViewController(keyboardHandlerViewController)
    view.addSubview(keyboardHandlerViewController.view)
    keyboardHandlerViewController.didMove(toParentViewController: self)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }
}

// MARK: - Private
fileprivate extension HomeViewController {
  func performSend() {
    homeViewModel?.sendTapped { success in
      guard success else {
        return
      }
      UIApplication.shared.delegate?.window??.rootViewController = TabViewController()
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
    if let checkboxCell = cell as? CheckboxCell {
      checkboxCell.delegate = self
    } else if let textFieldCell = cell as? TextFieldCell {
      textFieldCell.delegate = self
    } else if let sendCell = cell as? SendCell {
      sendCell.delegate = self
    }
    return cell
  }
}

// MARK: - UITableView Delegate
extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let selectionCell = tableView.cellForRow(at: indexPath) as? SelectionProtocol {
      defer {
        selectionCell.wasSelected()
      }
    }
  }
}

// MARK: - CheckboxCell Delegate
extension HomeViewController: CheckboxCellDelegate {
  func didChange(checkbox: CheckboxCell, to: Bool) {
    guard let indexPath = tableView.indexPath(for: checkbox) else {
      return
    }
    let cell = homeViewModel?.homeCellViewModels[indexPath.row]
    guard let show = cell?.show else {
      return
    }
    guard let newViewModel = homeViewModel?.show(show, show: to), let change = newViewModel.change else {
      return
    }
    tableView.beginUpdates()
    homeViewModel = newViewModel.newViewModel
    if change.insertion {
      let insertionIndexPath = IndexPath(row: change.index, section: 0)
      tableView.insertRows(at: [insertionIndexPath], with: .automatic)
    } else {
      let deletionIndexPath = IndexPath(row: change.index, section: 0)
      tableView.deleteRows(at: [deletionIndexPath], with: .top)
    }
    tableView.endUpdates()
  }
}

// MARK: - TextFieldCell Delegate
extension HomeViewController: TextFieldCellDelegate {
  func didEndEditing(cell: TextFieldCell, with text: String) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    homeViewModel = homeViewModel?.newText(text, at: indexPath.row)
  }
}

// MARK: - SendCell Delegate
extension HomeViewController: SendCellDelegate {
  func sendTapped() {
    performSend()
  }
}
