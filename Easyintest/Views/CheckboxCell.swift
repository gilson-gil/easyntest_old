//
//  CheckboxCell.swift
//  Easyintest
//
//  Created by Gilson Gil on 16/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

final class CheckboxCell: UITableViewCell {
  fileprivate static let buttonHeight: CGFloat = 30
  
  fileprivate let button: UIButton = {
    let button = UIButton()
    return button
  }()
  
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
    selectionStyle = .none
    
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    
    addSubview(button)
    addSubview(label)
    
    let margin = CGFloat(Constants.defaultMargin)
    constrain(button, label) { button, label in
      button.left == button.superview!.left + margin
      button.centerY == button.superview!.centerY
      button.width == CheckboxCell.buttonHeight
      button.height == CheckboxCell.buttonHeight
      
      label.left == button.right + margin
      label.bottom == label.superview!.bottom - margin
      label.right == label.superview!.right - margin
    }
    
    topPaddingConstraintGroup = constrain(label) { label in
      label.top == label.superview!.top + margin
    }
  }
}

// MARK: - Actions
extension CheckboxCell {
  func buttonTapped() {
    button.isSelected = !button.isSelected
  }
}

// MARK: - Updatable
extension CheckboxCell: Updatable {
  typealias ViewModel = HomeCellViewModel
  
  func update(_ viewModel: HomeCellViewModel) {
    label.text = viewModel.message
    topPaddingConstraintGroup = constrain(label, replace: topPaddingConstraintGroup) { label in
      label.top == label.superview!.top + CGFloat(viewModel.topSpacing)
    }
  }
}
