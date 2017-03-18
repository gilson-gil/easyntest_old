//
//  UpdatableCell.swift
//  courseslmem
//
//  Created by Gilson Gil on 9/9/16.
//  Copyright © 2016 Mejor Contigo S.L. All rights reserved.
//

import UIKit

protocol Updatable: class {
  associatedtype ViewModel
  
  func update(_ viewModel: ViewModel)
}

struct CellConfigurator<Cell> where Cell: Updatable {
  let viewModel: Cell.ViewModel
  let reuseIdentifier: String = NSStringFromClass(Cell.self).components(separatedBy: ".").last!
  let cellClass: AnyClass = Cell.self
  
  func update(_ cell: UITableViewCell) {
    if let cell = cell as? Cell {
      cell.update(viewModel)
    }
  }
  
  func update(_ cell: UICollectionViewCell) {
    if let cell = cell as? Cell {
      cell.update(viewModel)
    }
  }
  
  func update(_ header: UITableViewHeaderFooterView) {
    if let header = header as? Cell {
      header.update(viewModel)
    }
  }
  
  func register(_ tableView: UITableView?) {
    if cellClass.isSubclass(of: UITableViewCell.self) {
      tableView?.register(cellClass, forCellReuseIdentifier: reuseIdentifier)
    } else {
      tableView?.register(cellClass, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
  }
  
  func register(_ collectionView: UICollectionView?) {
    collectionView?.register(cellClass, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  func currentViewModel() -> Any {
    return viewModel
  }
}

protocol CellConfiguratorType {
  var reuseIdentifier: String { get }
  var cellClass: AnyClass { get }
  
  func update(_ cell: UITableViewCell)
  func update(_ cell: UICollectionViewCell)
  func update(_ header: UITableViewHeaderFooterView)
  func register(_ tableView: UITableView?)
  func register(_ collectionView: UICollectionView?)
  func currentViewModel() -> Any
}

extension CellConfigurator: CellConfiguratorType {}

extension UITableView {
  func register(_ configurators: [CellConfiguratorType]) {
    configurators.forEach {
      $0.register(self)
    }
  }
}

extension UICollectionView {
  func register(_ configurators: [CellConfiguratorType]) {
    configurators.forEach {
      $0.register(self)
    }
  }
}
