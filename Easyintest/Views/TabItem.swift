//
//  TabItem.swift
//  Easyintest
//
//  Created by Gilson Gil on 20/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit

final class TabItem: UIButton {
  fileprivate static let height: CGFloat = 2
  
  fileprivate let selectedLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.fillColor = UIColor.easySquash.cgColor
    layer.isHidden = true
    return layer
  }()
  
  override var isSelected: Bool {
    didSet {
      if isSelected {
        backgroundColor = UIColor.easyDarkSkyBlueFour
        selectedLayer.isHidden = false
      } else {
        backgroundColor = UIColor.easyDarkSkyBlueThree
        selectedLayer.isHidden = true
      }
    }
  }
  
  override var bounds: CGRect {
    didSet {
      let path = UIBezierPath(rect: CGRect(x: 0, y: -TabItem.height, width: bounds.width, height: TabItem.height))
      selectedLayer.path = path.cgPath
    }
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: -1, height: 60)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  init(title: String) {
    super.init(frame: .zero)
    setTitle(title, for: .normal)
    setUp()
  }
  
  private func setUp() {
    layer.addSublayer(selectedLayer)
    
    backgroundColor = UIColor.easyDarkSkyBlueThree
  }
}
