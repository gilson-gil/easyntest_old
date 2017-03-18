//
//  PhoneMask.swift
//  Easyintest
//
//  Created by Gilson Gil on 18/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation

struct PhoneMask {
  static func mask(text: String) -> String {
    let onlyDigits = text.onlyDigits()
    let masked = onlyDigits.applyMask()
    return masked
  }
}

fileprivate extension String {
  func onlyDigits() -> String {
    let stringArray = components(separatedBy: CharacterSet.decimalDigits.inverted)
    var newString = stringArray.joined(separator: "")
    if newString.characters.count > 11 {
      newString = newString.substring(to: newString.index(newString.startIndex, offsetBy: 11))
    }
    return newString
  }
  
  func applyMask() -> String {
    let count = characters.count
    var tempString = self
    if count > 0 {
      tempString.insert("(", at: tempString.startIndex)
    }
    if count > 2 {
      tempString.insert(")", at: tempString.index(tempString.startIndex, offsetBy: 3))
      tempString.insert(" ", at: tempString.index(tempString.startIndex, offsetBy: 4))
    }
    if count > 6 {
      if count == 11 {
        tempString.insert("-", at: tempString.index(tempString.endIndex, offsetBy: -4))
      } else {
        tempString.insert("-", at: tempString.index(tempString.startIndex, offsetBy: 9))
      }
    }
    return tempString
  }
}
