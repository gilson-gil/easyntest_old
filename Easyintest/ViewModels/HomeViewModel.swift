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
  
  init?() {
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
    let cellViewModels = cells.flatMap {
      HomeCellViewModel(cell: $0)
    }
    let configurators = cellViewModels.flatMap {
      $0.configurator()
    }
    self.homeCellViewModels = cellViewModels
    self.configurators = configurators
  }
}
