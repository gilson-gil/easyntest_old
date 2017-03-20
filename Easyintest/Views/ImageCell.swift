//
//  ImageCell.swift
//  Easyintest
//
//  Created by Gilson Gil on 16/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography
import Kingfisher

final class ImageCell: UITableViewCell {
  fileprivate let cellImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
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
    
    addSubview(cellImageView)
    
    let margin = CGFloat(Constants.defaultMargin)
    constrain(cellImageView) { cellImageView in
      cellImageView.left == cellImageView.superview!.left + margin
      cellImageView.bottom == cellImageView.superview!.bottom - margin
      cellImageView.right == cellImageView.superview!.right - margin
    }
    
    topPaddingConstraintGroup = constrain(cellImageView) { cellImageView in
      cellImageView.top == cellImageView.superview!.top + margin
    }
  }
}

// MARK: - Updatable
extension ImageCell: Updatable {
  typealias ViewModel = HomeCellViewModel
  
  func update(_ viewModel: HomeCellViewModel) {
    if let url = URL(string: viewModel.message) {
      let imageResource = ImageResource(downloadURL: url)
      cellImageView.kf.setImage(with: imageResource, placeholder: UIImage.easyImagePlaceholder, options: nil, progressBlock: nil, completionHandler: nil)
    } else {
      cellImageView.image = UIImage.easyImagePlaceholder
    }
    topPaddingConstraintGroup = constrain(cellImageView, replace: topPaddingConstraintGroup) { cellImageView in
      cellImageView.top == cellImageView.superview!.top + CGFloat(viewModel.topSpacing)
    }
  }
}
