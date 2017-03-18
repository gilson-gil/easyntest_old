//
//  PhoneValidationRule.swift
//  Easyintest
//
//  Created by Gilson Gil on 17/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation
import Validator

struct PhoneValidationRule: ValidationRule {
  typealias InputType = String
  
  var error: Error
  
  func validate(input: String?) -> Bool {
    guard let input = input else {
      return false
    }
    let regex = try? NSRegularExpression(pattern: "^\\([1-9]{2}\\) [2-9][0-9]{3,4}\\-[0-9]{4}$", options: NSRegularExpression.Options.caseInsensitive)
    guard let matches = regex?.matches(in: input, options: NSRegularExpression.MatchingOptions.anchored, range: NSMakeRange(0, input.characters.count)) else {
      return false
    }
    return matches.count > 0
  }
  
  init() {
    error = NSError()
  }
}
