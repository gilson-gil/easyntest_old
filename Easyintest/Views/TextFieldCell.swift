//
//  TextFieldCell.swift
//  Easyintest
//
//  Created by Gilson Gil on 16/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

final class TextFieldCell: UITableViewCell {
  fileprivate let textField: UITextField = {
    let textField = UITextField()
    textField.font = UIFont.easyRegularFont(ofSize: 18)
    textField.textColor = UIColor.easyAlmostBlack
    return textField
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
    
    addSubview(textField)
    
    let margin = CGFloat(Constants.defaultMargin)
    constrain(textField) { textField in
      textField.left == textField.superview!.left + margin
      textField.bottom == textField.superview!.bottom - margin
      textField.right == textField.superview!.right - margin
    }
    
    topPaddingConstraintGroup = constrain(textField) { textField in
      textField.top == textField.superview!.top + margin
    }
  }
}

// MARK: - Updatable
extension TextFieldCell: Updatable {
  typealias ViewModel = HomeCellViewModel
  
  func update(_ viewModel: HomeCellViewModel) {
    textField.attributedPlaceholder = NSAttributedString(string: viewModel.message, attributes: [NSForegroundColorAttributeName: UIColor.easyGreyish, NSFontAttributeName: UIFont.easyRegularFont(ofSize: 16)])
    topPaddingConstraintGroup = constrain(textField, replace: topPaddingConstraintGroup) { textField in
      textField.top == textField.superview!.top + CGFloat(viewModel.topSpacing)
    }
  }
}
