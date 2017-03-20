//
//  HomeViewModel.swift
//  Easyintest
//
//  Created by Gilson Gil on 16/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation

struct HomeViewModel {
  let homeCellViewModels: [HomeCellViewModel]
  let configurators: [CellConfiguratorType]
  
  init?(homeCellViewModels: [HomeCellViewModel]? = nil) {
    let cellViewModels: [HomeCellViewModel]
    if let homeCellViewModels = homeCellViewModels {
      cellViewModels = homeCellViewModels
    } else {
      guard let jsonPath = Bundle.main.path(forResource: "cells", ofType: "json") else {
        return nil
      }
      let url = URL(fileURLWithPath: jsonPath)
      guard let jsonData = try? Data(contentsOf: url), let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any], let json = jsonObject?["cells"] as? [[String: Any]] else {
        return nil
      }
      let cells = json.flatMap {
        Cell(json: $0)
      }
      cellViewModels = cells.flatMap {
        HomeCellViewModel(cell: $0)
      }
    }
    let configurators = cellViewModels.flatMap { cellViewModel -> CellConfiguratorType? in
      guard !cellViewModel.hidden else {
        return nil
      }
      return cellViewModel.configurator()
    }
    self.homeCellViewModels = cellViewModels
    self.configurators = configurators
  }
}

// MARK: - Public
extension HomeViewModel {
  func show(_ id: Int, show: Bool) -> (newViewModel: HomeViewModel, change: (insertion: Bool, index: Int)?) {
    let homeCellViewModel = self.homeCellViewModels.filter {
      $0.cellId == id
    }
    guard let cellViewModel = homeCellViewModel.first else {
      return (newViewModel: self, change: nil)
    }
    let newCellViewModel = cellViewModel.show(show)
    
    var homeCellViewModels = self.homeCellViewModels
    var index = 0
    self.homeCellViewModels.enumerated().forEach { offset, element in
      guard element.cellId == cellViewModel.cellId else {
        return
      }
      index = offset
      homeCellViewModels[offset] = newCellViewModel
    }
    let viewModel = HomeViewModel(homeCellViewModels: homeCellViewModels)
    guard let aViewModel = viewModel else {
      return (newViewModel: self, change: nil)
    }
    return (newViewModel: aViewModel, change: (insertion: show, index: index))
  }
  
  func newText(_ text: String, at index: Int) -> HomeViewModel {
    let oldViewModel = homeCellViewModels[index]
    let newViewModel = oldViewModel.set(text: text)
    var viewModels = homeCellViewModels
    viewModels.remove(at: index)
    viewModels.insert(newViewModel, at: index)
    let viewModel = HomeViewModel(homeCellViewModels: viewModels)
    return viewModel ?? self
  }
  
  func sendTapped(_ completion: (Bool) -> ()) {
    let notValidated = homeCellViewModels.filter {
      !$0.validate()
    }
    guard notValidated.count > 0 else {
      completion(false)
      return
    }
    completion(true)
  }
}
