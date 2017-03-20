//
//  InvestmentRiskCell.swift
//  Easyintest
//
//  Created by Gilson Gil on 20/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

final class InvestmentRiskCell: UITableViewCell {
  fileprivate let label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 16)
    label.textAlignment = .center
    label.textColor = UIColor.easyDarkSkyBlueThree
    return label
  }()
  
  fileprivate let indicatorView: UIImageView = {
    let image = UIImage.easyImageIndicator
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    imageView.isHidden = true
    return imageView
  }()
  
  fileprivate let riskGrade: RiskGrade = {
    let riskGrade = RiskGrade()
    return riskGrade
  }()
  
  fileprivate var indicatorCenterConstraintGroup: ConstraintGroup?
  
  override var bounds: CGRect {
    didSet {
      update()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUp()
  }
  
  private func setUp() {
    backgroundColor = .white
    selectionStyle = .none
    
    addSubview(label)
    addSubview(indicatorView)
    addSubview(riskGrade)
    
    let margin = CGFloat(Constants.defaultMargin)
    constrain(label, indicatorView, riskGrade) { label, indicatorView, riskGrade in
      label.top == label.superview!.top + margin
      label.left == label.superview!.left + margin
      label.right == label.superview!.right - margin
      
      indicatorView.top == label.bottom + margin
      
      riskGrade.top == indicatorView.bottom + margin / 2
      riskGrade.left == riskGrade.superview!.left + margin
      riskGrade.bottom == riskGrade.superview!.bottom - margin
      riskGrade.right == riskGrade.superview!.right - margin
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    update()
  }
}

// MARK: - Updatable
extension InvestmentRiskCell: Updatable {
  typealias ViewModel = InvestmentRiskGradeViewModel
  
  func update(_ viewModel: InvestmentRiskGradeViewModel) {
    label.text = viewModel.riskTitle
    riskGrade.risk = viewModel.risk
    indicatorView.isHidden = viewModel.risk < 1 && viewModel.risk > 5
    let centerX = CGFloat(-3 + viewModel.risk) / 5 * riskGrade.bounds.width
    indicatorCenterConstraintGroup = constrain(indicatorView, riskGrade, replace: indicatorCenterConstraintGroup) { indicatorView, riskGrade in
      indicatorView.centerX == riskGrade.centerX + centerX
    }
  }
  
  func update() {
    let centerX = CGFloat(-3 + riskGrade.risk) / 5 * riskGrade.bounds.width
    indicatorCenterConstraintGroup = constrain(indicatorView, riskGrade, replace: indicatorCenterConstraintGroup) { indicatorView, riskGrade in
      indicatorView.centerX == riskGrade.centerX + centerX
    }
  }
}
