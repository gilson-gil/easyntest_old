//
//  LabelCell.swift
//  Easyintest
//
//  Created by Gilson Gil on 16/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

final class LabelCell: UITableViewCell {
  fileprivate let label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 16)
    label.textAlignment = .center
    label.textColor = UIColor.easyGreyish
    return label
  }()
  
  fileprivate var topPaddingConstraintGroup: ConstraintGroup?
  
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
    
    let margin = CGFloat(Constants.defaultMargin)
    constrain(label) { label in
      label.left == label.superview!.left + margin
      label.bottom == label.superview!.bottom - margin
      label.right == label.superview!.right - margin
    }
    
    topPaddingConstraintGroup = constrain(label) { label in
      label.top == label.superview!.top + margin
    }
  }
}

// MARK: - Updatable
extension LabelCell: Updatable {
  typealias ViewModel = HomeCellViewModel
  
  func update(_ viewModel: HomeCellViewModel) {
    label.text = viewModel.message
    topPaddingConstraintGroup = constrain(label, replace: topPaddingConstraintGroup) { label in
      label.top == label.superview!.top + CGFloat(viewModel.topSpacing)
    }
  }
}
