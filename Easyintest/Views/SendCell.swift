//
//  SendCell.swift
//  Easyintest
//
//  Created by Gilson Gil on 16/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

final class SendCell: UITableViewCell {
  fileprivate static let buttonHeight: CGFloat = 50
  
  fileprivate let button: ActionButton = {
    let button = ActionButton()
    return button
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
    
    let margin = CGFloat(Constants.defaultMargin)
    constrain(button) { button in
      button.left == button.superview!.left + margin
      button.bottom == button.superview!.bottom - margin
      button.right == button.superview!.right - margin
      button.height == SendCell.buttonHeight
    }
    
    topPaddingConstraintGroup = constrain(button) { button in
      button.top == button.superview!.top + margin
    }
  }
}

// MARK: - Actions
extension SendCell {
  func buttonTapped() {
    
  }
}

// MARK: - Updatable
extension SendCell: Updatable {
  typealias ViewModel = HomeCellViewModel
  
  func update(_ viewModel: HomeCellViewModel) {
    button.setTitle(viewModel.message, for: .normal)
    topPaddingConstraintGroup = constrain(button, replace: topPaddingConstraintGroup) { button in
      button.top == button.superview!.top + CGFloat(viewModel.topSpacing)
    }
  }
}
