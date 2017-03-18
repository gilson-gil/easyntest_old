//
//  HomeCellViewModel.swift
//  Easyintest
//
//  Created by Gilson Gil on 16/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit

struct HomeCellViewModel {
  let cellId: Int
  let type: CellType
  let message: String
  let typeField: TypeField?
  let hidden: Bool
  let topSpacing: Float
  let show: Int?
  let required: Bool
  
  init(cell: Cell) {
    cellId = cell.id
    type = cell.type
    message = cell.message
    typeField = cell.typeField
    hidden = cell.hidden
    topSpacing = cell.topSpacing
    show = cell.show
    required = cell.required
  }
  
  fileprivate init(cellId: Int, type: CellType, message: String, typeField: TypeField?, hidden: Bool, topSpacing: Float, show: Int?, required: Bool) {
    self.cellId = cellId
    self.type = type
    self.message = message
    self.typeField = typeField
    self.hidden = hidden
    self.topSpacing = topSpacing
    self.show = show
    self.required = required
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
  
  func show(_ show: Bool) -> HomeCellViewModel {
    let viewModel = HomeCellViewModel(cellId: cellId, type: type, message: message, typeField: typeField, hidden: !show, topSpacing: topSpacing, show: self.show, required: required)
    return viewModel
  }
}
