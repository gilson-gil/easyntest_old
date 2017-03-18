//
//  Checkbox.swift
//  Easyintest
//
//  Created by Gilson Gil on 18/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit

final class Checkbox: UIButton {
  fileprivate static let padding: CGFloat = 3
  
  fileprivate let selectionLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.fillColor = UIColor.easyDarkSkyBlue.cgColor
    layer.borderColor = UIColor.white.cgColor
    layer.borderWidth = 2
    layer.cornerRadius = 4
    layer.isHidden = true
    return layer
  }()
  
  override var bounds: CGRect {
    didSet {
      let path = UIBezierPath(rect: CGRect(x: Checkbox.padding, y: Checkbox.padding, width: bounds.width - 2 * Checkbox.padding, height: bounds.height - 2 * Checkbox.padding))
      selectionLayer.path = path.cgPath
    }
  }
  
  override var isSelected: Bool {
    didSet {
      selectionLayer.isHidden = !isSelected
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
    layer.addSublayer(selectionLayer)
    
    layer.cornerRadius = 4
    layer.borderColor = UIColor.easyWarmGrey.cgColor
    layer.borderWidth = 1.5
    
    addTarget(self, action: #selector(tapped), for: .touchUpInside)
  }
}

// MARK: - Actions
extension Checkbox {
  func tapped() {
    isSelected = !isSelected
  }
}
