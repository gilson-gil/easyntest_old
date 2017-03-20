//
//  TextFieldCell.swift
//  Easyintest
//
//  Created by Gilson Gil on 16/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

protocol TextFieldCellDelegate: class {
  func didEndEditing(cell: TextFieldCell, with text: String)
}

final class TextFieldCell: UITableViewCell {
  fileprivate let textField: StatefulTextField = {
    let textField = StatefulTextField()
    textField.font = UIFont.easyRegularFont(ofSize: 18)
    textField.textColor = UIColor.easyAlmostBlack
    return textField
  }()
  
  fileprivate var topPaddingConstraintGroup: ConstraintGroup?
  
  weak var delegate: TextFieldCellDelegate?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUp()
  }
  
  private func setUp() {
    textField.statefulDelegate = self
    
    backgroundColor = .white
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
    if let text = viewModel.fieldText {
      textField.text = text
    }
    textField.attributedPlaceholder = NSAttributedString(string: viewModel.message, attributes: [NSForegroundColorAttributeName: UIColor.easyGreyish, NSFontAttributeName: UIFont.easyRegularFont(ofSize: 16)])
    textField.typeField = viewModel.typeField
    topPaddingConstraintGroup = constrain(textField, replace: topPaddingConstraintGroup) { textField in
      textField.top == textField.superview!.top + CGFloat(viewModel.topSpacing)
    }
  }
}

// MARK: - Selection Protocol
extension TextFieldCell: SelectionProtocol {
  func wasSelected() {
    let _ = textField.becomeFirstResponder()
  }
}

// MARK: - StatefulTextField Delegate
extension TextFieldCell: StatefulTextFieldDelegate {
  func didEndEditing(with text: String) {
    delegate?.didEndEditing(cell: self, with: text)
  }
}
