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
}
