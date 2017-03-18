//
//  ValidatorProtocol.swift
//  Easyintest
//
//  Created by Gilson Gil on 16/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation
import Validator

enum ValidatorType {
  case text, phone, email
}

protocol ValidatorProtocol {
  func validated() -> Bool
  func validatorType() -> ValidatorType
  func validatorObject() -> String?
}

extension ValidatorProtocol {
  func validated() -> Bool {
    guard let object = validatorObject() else {
      return false
    }
    switch validatorType() {
    case .text:
      return object.characters.count > 0
    case .phone:
      let rule = PhoneValidationRule()
      return rule.validate(input: object)
    case .email:
      let error = NSError()
      let rule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: error)
      return rule.validate(input: object)
    }
  }
}
