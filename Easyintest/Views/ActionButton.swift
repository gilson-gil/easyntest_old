//
//  ActionButton.swift
//  Easyintest
//
//  Created by Gilson Gil on 18/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit

final class ActionButton: UIButton {
  override var bounds: CGRect {
    didSet {
      layer.cornerRadius = bounds.height / 2
    }
  }
  
  override var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        backgroundColor = UIColor.easySoftBlue
      } else {
        backgroundColor = UIColor.easyDarkSkyBlueTwo
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  init() {
    super.init(frame: .zero)
    setUp()
  }
  
  private func setUp() {
    backgroundColor = UIColor.easyDarkSkyBlueTwo
    setTitleColor(UIColor.white, for: .normal)
    titleLabel?.font = UIFont.easyRegularFont(ofSize: 16)
  }
}
