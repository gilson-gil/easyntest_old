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
  fileprivate static let buttonHeight: CGFloat = 24
  
  fileprivate let checkbox: Checkbox = {
    let checkbox = Checkbox()
    return checkbox
  }()
  
  fileprivate let label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 16)
    label.textAlignment = .center
    label.textColor = UIColor.easyGreyish
    label.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
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
    
    let containerView = createContainerView()
    addSubview(containerView)
    containerView.addSubview(checkbox)
    containerView.addSubview(label)
    
    let margin = CGFloat(Constants.defaultMargin)
    constrain(containerView) { containerView in
      containerView.top >= containerView.superview!.top
      containerView.left >= containerView.superview!.left
      containerView.bottom <= containerView.superview!.bottom
      containerView.right <= containerView.superview!.right
      containerView.center == containerView.superview!.center
    }
    
    constrain(checkbox, label) { checkbox, label in
      checkbox.left == checkbox.superview!.left + margin
      checkbox.width == CheckboxCell.buttonHeight
      checkbox.height == CheckboxCell.buttonHeight
      
      label.left == checkbox.right + margin
      label.bottom == label.superview!.bottom - margin
      label.right == label.superview!.right - margin
      label.centerY == checkbox.centerY
    }
    
    topPaddingConstraintGroup = constrain(label) { label in
      label.top == label.superview!.top + margin
    }
  }
}

// MARK: - Views
fileprivate extension CheckboxCell {
  func createContainerView() -> UIView {
    let view = UIView()
    view.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
    view.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
    return view
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

// MARK: - Selection Protocol
extension CheckboxCell: SelectionProtocol {
  func wasSelected() {
    checkbox.isSelected = !checkbox.isSelected
  }
}
