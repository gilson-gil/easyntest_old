//
//  InvestmentDescriptionCell.swift
//  Easyintest
//
//  Created by Gilson Gil on 20/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

final class InvestmentDescriptionCell: UITableViewCell {
  fileprivate let label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.easyRegularFont(ofSize: 16)
    label.textAlignment = .center
    label.textColor = UIColor.easyWarmGrey
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
    
    let imageView = createImageView()
    addSubview(imageView)
    addSubview(label)
    
    let margin = CGFloat(Constants.defaultMargin)
    constrain(imageView, label) { imageView, label in
      imageView.top == imageView.superview!.top
      imageView.left == imageView.superview!.left + 2 * margin
      imageView.right == imageView.superview!.right - 2 * margin
      
      label.top == imageView.bottom + margin
      label.left == label.superview!.left + margin
      label.bottom == label.superview!.bottom - margin
      label.right == label.superview!.right - margin
    }
  }
}

// MARK: - Views
fileprivate extension InvestmentDescriptionCell {
  func createImageView() -> UIImageView {
    let image = UIImage.easyImageSeparator
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }
}

// MARK: - Updatable
extension InvestmentDescriptionCell: Updatable {
  typealias ViewModel = InvestmentDescriptionViewModel
  
  func update(_ viewModel: InvestmentDescriptionViewModel) {
    label.text = viewModel.text
  }
}
