//
//  RiskGrade.swift
//  Easyintest
//
//  Created by Gilson Gil on 20/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

final class RiskGrade: UIView {
  fileprivate static let height: CGFloat = 10
  
  fileprivate let riskOneView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.easyRiskOne
    return view
  }()
  
  fileprivate let riskTwoView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.easyRiskTwo
    return view
  }()
  
  fileprivate let riskThreeView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.easyRiskThree
    return view
  }()
  
  fileprivate let riskFourView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.easyRiskFour
    return view
  }()
  
  fileprivate let riskFiveView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.easyRiskFive
    return view
  }()
  
  fileprivate var heightConstraintGroup: ConstraintGroup?
  
  override var bounds: CGRect {
    didSet {
      layer.cornerRadius = bounds.height / 2
    }
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: -1, height: RiskGrade.height)
  }
  
  var risk: Int = 0 {
    didSet {
      heightConstraintGroup = constrain(riskOneView, riskTwoView, riskThreeView, riskFourView, riskFiveView, replace: heightConstraintGroup) { riskOneView, riskTwoView, riskThreeView, riskFourView, riskFiveView in
        riskOneView.height == ((risk == 1) ? RiskGrade.height : RiskGrade.height * 0.6)
        riskTwoView.height == ((risk == 2) ? RiskGrade.height : RiskGrade.height * 0.6)
        riskThreeView.height == ((risk == 3) ? RiskGrade.height : RiskGrade.height * 0.6)
        riskFourView.height == ((risk == 4) ? RiskGrade.height : RiskGrade.height * 0.6)
        riskFiveView.height == ((risk == 5) ? RiskGrade.height : RiskGrade.height * 0.6)
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
    clipsToBounds = true
    
    addSubview(riskOneView)
    addSubview(riskTwoView)
    addSubview(riskThreeView)
    addSubview(riskFourView)
    addSubview(riskFiveView)
    
    constrain(riskOneView, riskTwoView, riskThreeView, riskFourView, riskFiveView) { riskOneView, riskTwoView, riskThreeView, riskFourView, riskFiveView in
      riskOneView.left == riskOneView.superview!.left
      riskOneView.centerY == riskOneView.superview!.centerY
      
      riskTwoView.left == riskOneView.right + 1
      riskTwoView.centerY == riskTwoView.superview!.centerY
      riskTwoView.width == riskOneView.width
      
      riskThreeView.left == riskTwoView.right + 1
      riskThreeView.centerY == riskThreeView.superview!.centerY
      riskThreeView.width == riskTwoView.width
      
      riskFourView.left == riskThreeView.right + 1
      riskFourView.centerY == riskFourView.superview!.centerY
      riskFourView.width == riskThreeView.width
      
      riskFiveView.left == riskFourView.right + 1
      riskFiveView.right == riskFiveView.superview!.right
      riskFiveView.centerY == riskFiveView.superview!.centerY
      riskFiveView.width == riskFourView.width
    }
    
    heightConstraintGroup = constrain(riskOneView, riskTwoView, riskThreeView, riskFourView, riskFiveView) { riskOneView, riskTwoView, riskThreeView, riskFourView, riskFiveView in
      riskOneView.height == RiskGrade.height / 2
      riskTwoView.height == RiskGrade.height / 2
      riskThreeView.height == RiskGrade.height / 2
      riskFourView.height == RiskGrade.height / 2
      riskFiveView.height == RiskGrade.height / 2
    }
  }
}
