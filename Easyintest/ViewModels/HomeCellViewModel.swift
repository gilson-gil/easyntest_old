//
//  HomeCellViewModel.swift
//  Easyintest
//
//  Created by Gilson Gil on 16/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit

struct HomeCellViewModel {
  let type: CellType
  let message: String
  let typeField: TypeField?
  let hidden: Bool
  let topSpacing: Float
  let show: Bool
  let required: Bool
  
  init(cell: Cell) {
    type = cell.type
    message = cell.message
    typeField = cell.typeField
    hidden = cell.hidden
    topSpacing = cell.topSpacing
    show = cell.show
    required = cell.required
  }
}

// MARK: - Public
extension HomeCellViewModel {
  func configurator() -> CellConfiguratorType {
    let configurator: CellConfiguratorType
    switch type {
    case .text:
      configurator = CellConfigurator<LabelCell>(viewModel: self)
    case .field:
      configurator = CellConfigurator<TextFieldCell>(viewModel: self)
    case .checkbox:
      configurator = CellConfigurator<CheckboxCell>(viewModel: self)
    case .image:
      configurator = CellConfigurator<ImageCell>(viewModel: self)
    case .send:
      configurator = CellConfigurator<SendCell>(viewModel: self)
    }
    return configurator
  }
}
