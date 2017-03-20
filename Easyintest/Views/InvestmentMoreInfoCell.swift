//
//  InvestmentMoreInfoCell.swift
//  Easyintest
//
//  Created by Gilson Gil on 20/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

final class InvestmentMoreInfoCell: UITableViewCell {
  fileprivate let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 16)
    label.textAlignment = .center
    label.textColor = UIColor.easyDarkSkyBlueThree
    label.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
    return label
  }()
  
  fileprivate let fundHeaderLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 14)
    label.textAlignment = .right
    label.textColor = UIColor.easyGreyish
    label.text = "Fundo"
    return label
  }()
  
  fileprivate let cdiHeaderLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 14)
    label.textAlignment = .right
    label.textColor = UIColor.easyGreyish
    label.text = "CDI"
    return label
  }()
  
  fileprivate let monthHeaderLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 14)
    label.textAlignment = .left
    label.textColor = UIColor.easyGreyish
    label.text = "No mês"
    return label
  }()
  
  fileprivate let yearHeaderLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 14)
    label.textAlignment = .left
    label.textColor = UIColor.easyGreyish
    label.text = "No ano"
    return label
  }()
  
  fileprivate let twelveHeaderLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 14)
    label.textAlignment = .left
    label.textColor = UIColor.easyGreyish
    label.text = "12 meses"
    return label
  }()
  
  fileprivate let monthFundLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 14)
    label.textAlignment = .right
    label.textColor = UIColor.easyAlmostBlack
    return label
  }()
  
  fileprivate let monthCDILabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 14)
    label.textAlignment = .right
    label.textColor = UIColor.easyAlmostBlack
    return label
  }()
  
  fileprivate let yearFundLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 14)
    label.textAlignment = .right
    label.textColor = UIColor.easyAlmostBlack
    return label
  }()
  
  fileprivate let yearCDILabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 14)
    label.textAlignment = .right
    label.textColor = UIColor.easyAlmostBlack
    return label
  }()
  
  fileprivate let twelveFundLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 14)
    label.textAlignment = .right
    label.textColor = UIColor.easyAlmostBlack
    return label
  }()
  
  fileprivate let twelveCDILabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 14)
    label.textAlignment = .right
    label.textColor = UIColor.easyAlmostBlack
    return label
  }()
  
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
    
    addSubview(titleLabel)
    addSubview(fundHeaderLabel)
    addSubview(cdiHeaderLabel)
    addSubview(monthHeaderLabel)
    addSubview(yearHeaderLabel)
    addSubview(twelveHeaderLabel)
    addSubview(monthFundLabel)
    addSubview(monthCDILabel)
    addSubview(yearFundLabel)
    addSubview(yearCDILabel)
    addSubview(twelveFundLabel)
    addSubview(twelveCDILabel)
    
    let margin = CGFloat(Constants.defaultMargin)
    constrain(titleLabel, fundHeaderLabel, cdiHeaderLabel, monthFundLabel, monthCDILabel) { titleLabel, fundHeaderLabel, cdiHeaderLabel, monthFundLabel, monthCDILabel in
      titleLabel.top == titleLabel.superview!.top + margin
      titleLabel.left == titleLabel.superview!.left + margin
      titleLabel.right == titleLabel.superview!.right - margin
      
      fundHeaderLabel.top == titleLabel.bottom + margin
      fundHeaderLabel.left == fundHeaderLabel.superview!.centerX
      fundHeaderLabel.right == cdiHeaderLabel.left
      
      cdiHeaderLabel.top == titleLabel.bottom + margin
      cdiHeaderLabel.right == cdiHeaderLabel.superview!.right - margin
      cdiHeaderLabel.width == fundHeaderLabel.width
      
      monthFundLabel.top == fundHeaderLabel.bottom + margin
      monthFundLabel.left == fundHeaderLabel.left
      monthFundLabel.right == fundHeaderLabel.right
      
      monthCDILabel.top == cdiHeaderLabel.bottom + margin
      monthCDILabel.left == cdiHeaderLabel.left
      monthCDILabel.right == cdiHeaderLabel.right
    }
    
    constrain(monthHeaderLabel, monthFundLabel, monthCDILabel, yearHeaderLabel, twelveHeaderLabel) { monthHeaderLabel, monthFundLabel, monthCDILabel, yearHeaderLabel, twelveHeaderLabel in
      monthHeaderLabel.top == monthFundLabel.top
      monthHeaderLabel.left == monthHeaderLabel.superview!.left + margin
      monthHeaderLabel.right == monthHeaderLabel.superview!.centerX
      
      yearHeaderLabel.top == monthHeaderLabel.bottom + margin
      yearHeaderLabel.left == monthHeaderLabel.left
      yearHeaderLabel.right == monthHeaderLabel.right
      
      twelveHeaderLabel.top == yearHeaderLabel.bottom + margin
      twelveHeaderLabel.left == yearHeaderLabel.left
      twelveHeaderLabel.right == yearHeaderLabel.right
    }
    
    constrain(monthFundLabel, monthCDILabel, yearFundLabel, yearCDILabel) { monthFundLabel, monthCDILabel, yearFundLabel, yearCDILabel in
      yearFundLabel.top == monthFundLabel.bottom + margin
      yearFundLabel.left == monthFundLabel.left
      yearFundLabel.right == monthFundLabel.right
      
      yearCDILabel.top == monthCDILabel.bottom + margin
      yearCDILabel.left == monthCDILabel.left
      yearCDILabel.right == monthCDILabel.right
    }
    
    constrain(yearFundLabel, yearCDILabel, twelveFundLabel, twelveCDILabel) { yearFundLabel, yearCDILabel, twelveFundLabel, twelveCDILabel in
      twelveFundLabel.top == yearFundLabel.bottom + margin
      twelveFundLabel.left == yearFundLabel.left
      twelveFundLabel.bottom == twelveFundLabel.superview!.bottom - margin
      twelveFundLabel.right == yearFundLabel.right
      
      twelveCDILabel.top == yearCDILabel.bottom + margin
      twelveCDILabel.left == yearCDILabel.left
      twelveCDILabel.bottom == twelveCDILabel.superview!.bottom - margin
      twelveCDILabel.right == yearCDILabel.right
    }
  }
}

// MARK: - Updatable
extension InvestmentMoreInfoCell: Updatable {
  typealias ViewModel = InvestmentMoreInfoViewModel
  
  func update(_ viewModel: InvestmentMoreInfoViewModel) {
    titleLabel.text = viewModel.title
    monthFundLabel.text = viewModel.monthFund + "%"
    monthCDILabel.text = viewModel.monthCDI + "%"
    yearFundLabel.text = viewModel.yearFund + "%"
    yearCDILabel.text = viewModel.yearCDI + "%"
    twelveFundLabel.text = viewModel.twelveFund + "%"
    twelveCDILabel.text = viewModel.twelveCDI + "%"
  }
}
