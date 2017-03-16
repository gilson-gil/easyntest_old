//
//  Cell.swift
//  Easyintest
//
//  Created by Gilson Gil on 16/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation

enum CellType: Int {
  case field = 1
  case text
  case image
  case checkbox
  case send
}

enum TypeField: Int {
  case text = 1
  case telNumber
  case email
}

struct Cell {
  let id: Int
  let type: CellType
  let message: String
  let typeField: TypeField?
  let hidden: Bool
  let topSpacing: Float
  let show: Bool
  let required: Bool
  
  init(json: [String: Any]) {
    id = json["id"] as? Int ?? 0
    type = CellType(rawValue: json["type"] as? Int ?? 1) ?? .text
    message = json["message"] as? String ?? ""
    typeField = TypeField(rawValue: json["typefield"] as? Int ?? 0)
    hidden = json["hidden"] as? Bool ?? true
    topSpacing = json["topSpacing"] as? Float ?? Constants.defaultMargin
    show = json["show"] as? Bool ?? false
    required = json["required"] as? Bool ?? false
  }
}
