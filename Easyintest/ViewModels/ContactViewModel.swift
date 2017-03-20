//
//  ContactViewModel.swift
//  Easyintest
//
//  Created by Gilson Gil on 20/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation

struct ContactViewModel {
  let viewModels: [HomeCellViewModel]
  let configurators: [CellConfiguratorType]
  
  init?(viewModels: [HomeCellViewModel]? = nil) {
    let cellViewModels: [HomeCellViewModel]
    if let homeCellViewModels = viewModels {
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
    self.viewModels = cellViewModels
    self.configurators = configurators
  }
}

// MARK: - Public
extension ContactViewModel {
  func show(_ id: Int, show: Bool) -> (newViewModel: ContactViewModel, change: (insertion: Bool, index: Int)?) {
    let homeCellViewModel = self.viewModels.filter {
      $0.cellId == id
    }
    guard let cellViewModel = homeCellViewModel.first else {
      return (newViewModel: self, change: nil)
    }
    let newCellViewModel = cellViewModel.show(show)
    
    var homeCellViewModels = self.viewModels
    var index = 0
    self.viewModels.enumerated().forEach { offset, element in
      guard element.cellId == cellViewModel.cellId else {
        return
      }
      index = offset
      homeCellViewModels[offset] = newCellViewModel
    }
    let viewModel = ContactViewModel(viewModels: homeCellViewModels)
    guard let aViewModel = viewModel else {
      return (newViewModel: self, change: nil)
    }
    return (newViewModel: aViewModel, change: (insertion: show, index: index))
  }
  
  func newText(_ text: String, at index: Int) -> ContactViewModel {
    let hiddenItems = self.viewModels.enumerated().filter {
      $0.element.hidden && $0.offset <= index
    }
    let adjustedIndex = index + hiddenItems.count
    let oldViewModel = self.viewModels[adjustedIndex]
    let newViewModel = oldViewModel.set(text: text)
    var viewModels = self.viewModels
    viewModels.remove(at: adjustedIndex)
    viewModels.insert(newViewModel, at: adjustedIndex)
    let viewModel = ContactViewModel(viewModels: viewModels)
    return viewModel ?? self
  }
  
  func sendTapped(_ completion: (Bool) -> ()) {
    let notValidated = viewModels.filter {
      !$0.validate()
    }
    guard notValidated.count == 0 else {
      completion(false)
      return
    }
    completion(true)
  }
}
