//
//  InvestmentTitleCell.swift
//  Easyintest
//
//  Created by Gilson Gil on 20/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

final class InvestmentTitleCell: UITableViewCell {
  fileprivate let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 14)
    label.textAlignment = .center
    label.textColor = UIColor.easyWarmGrey
    return label
  }()
  
  fileprivate let contentLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 36)
    label.textAlignment = .center
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
    addSubview(contentLabel)
    
    let margin = CGFloat(Constants.defaultMargin)
    constrain(titleLabel, contentLabel) { titleLabel, contentLabel in
      titleLabel.top == titleLabel.superview!.top + margin
      titleLabel.left == titleLabel.superview!.left + margin
      titleLabel.right == titleLabel.superview!.right - margin
      
      contentLabel.top == titleLabel.bottom + margin
      contentLabel.left == contentLabel.superview!.left + margin
      contentLabel.bottom == contentLabel.superview!.bottom - margin
      contentLabel.right == contentLabel.superview!.right - margin
    }
  }
}

// MARK: - Updatable
extension InvestmentTitleCell: Updatable {
  typealias ViewModel = InvestmentHeaderViewModel
  
  func update(_ viewModel: InvestmentHeaderViewModel) {
    titleLabel.text = viewModel.title
    contentLabel.text = viewModel.content
  }
}
