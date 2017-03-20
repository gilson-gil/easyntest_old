//
//  InvestmentInfoCell.swift
//  Easyintest
//
//  Created by Gilson Gil on 20/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

final class InvestmentInfoCell: UITableViewCell {
  fileprivate let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 14)
    label.textAlignment = .left
    label.textColor = UIColor.easyGreyish
    label.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
    return label
  }()
  
  fileprivate let contentLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 14)
    label.textAlignment = .right
    label.textColor = UIColor.easyAlmostBlack
    label.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
    return label
  }()
  
  fileprivate let downloadButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage.easySetaBaixar, for: .normal)
    button.isHidden = true
    button.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
    return button
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
    addSubview(downloadButton)
    
    let margin = CGFloat(Constants.defaultMargin)
    constrain(titleLabel, contentLabel, downloadButton) { titleLabel, contentLabel, downloadButton in
      titleLabel.top == titleLabel.superview!.top + margin
      titleLabel.left == titleLabel.superview!.left + margin
      titleLabel.bottom == titleLabel.superview!.bottom - margin
      
      downloadButton.left == titleLabel.right + margin
      downloadButton.right == contentLabel.left - margin
      downloadButton.centerY == downloadButton.superview!.centerY
      
      contentLabel.top == contentLabel.superview!.top + margin
      contentLabel.left == downloadButton.right + margin
      contentLabel.bottom == contentLabel.superview!.bottom - margin
      contentLabel.right == contentLabel.superview!.right - margin
    }
    
    downloadButton.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
  }
}

// MARK: - Actions
extension InvestmentInfoCell {
  func downloadTapped() {
    
  }
}

// MARK: - Updatable
extension InvestmentInfoCell: Updatable {
  typealias ViewModel = InvestmentInfoViewModel
  
  func update(_ viewModel: InvestmentInfoViewModel) {
    titleLabel.text = viewModel.title
    if let content = viewModel.content {
      contentLabel.text = content
      contentLabel.textColor = UIColor.easyAlmostBlack
      downloadButton.isHidden = true
    } else {
      contentLabel.text = "Baixar"
      contentLabel.textColor = UIColor.easyDarkSkyBlueThree
      downloadButton.isHidden = false
    }
  }
}

// MARK: - Selection Protocol
extension InvestmentInfoCell: SelectionProtocol {
  func wasSelected() {
    downloadTapped()
  }
}
