//
//  StatefulTextField.swift
//  Easyintest
//
//  Created by Gilson Gil on 16/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit

enum StatefulTextFieldState {
  case inactive, active, fail, success
}

protocol StatefulTextFieldDelegate: class {
  func didEndEditing(with text: String)
}

final class StatefulTextField: UITextField {
  fileprivate static let placeholderScaleFactor: CGFloat = 0.8
  fileprivate static let clearButtonSize: CGFloat = 30
  
  var typeField: TypeField? {
    didSet {
      guard let typeField = typeField else {
        return
      }
      switch typeField {
      case .telNumber:
        keyboardType = .phonePad
      case .email:
        keyboardType = .emailAddress
        autocapitalizationType = .none
        autocorrectionType = .no
      case .text:
        keyboardType = .default
        autocapitalizationType = .sentences
        autocorrectionType = .default
      }
    }
  }
  
  fileprivate let lineLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = UIColor.easyAlmostWhite.cgColor
    layer.lineWidth = 1
    return layer
  }()
  
  fileprivate let placeholderLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.easyRegularFont(ofSize: 16)
    label.textColor = .lightGray
    return label
  }()
  
  fileprivate var statefulState: StatefulTextFieldState = .inactive {
    didSet {
      switch statefulState {
      case .inactive:
        lineLayer.strokeColor = UIColor.easyAlmostWhite.cgColor
      case .active:
        lineLayer.strokeColor = UIColor.easyGreyish.cgColor
      case .fail:
        lineLayer.strokeColor = UIColor.easyOrangeRed.cgColor
      case .success:
        lineLayer.strokeColor = UIColor.easyGrass.cgColor
      }
    }
  }
  
  override var bounds: CGRect {
    didSet {
      let rect = CGRect(x: 0, y: bounds.height, width: bounds.width, height: 0)
      lineLayer.path = UIBezierPath(rect: rect).cgPath
      placeholderLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
      if text == nil || text?.characters.count == 0 {
        resetPlaceholderLabel()
      } else {
        fixPlaceholderLabel()
      }
    }
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return .zero
  }
  
  override var placeholder: String? {
    willSet (value) {
      placeholderLabel.text = value
    }
  }
  
  override var attributedPlaceholder: NSAttributedString? {
    willSet (value) {
      placeholderLabel.text = value?.string
      if let textColor = value?.attribute(NSForegroundColorAttributeName, at: 0, effectiveRange: nil) as? UIColor {
        placeholderLabel.textColor = textColor
      }
      if let font = value?.attribute(NSFontAttributeName, at: 0, effectiveRange: nil) as? UIFont {
        placeholderLabel.font = font
      }
    }
  }
  
  override func becomeFirstResponder() -> Bool {
    statefulState = .active
    lineLayer.lineWidth = 2
    fixPlaceholderLabel()
    return super.becomeFirstResponder()
  }
  
  override func resignFirstResponder() -> Bool {
    statefulState = .inactive
    lineLayer.lineWidth = 1
    guard text == nil || text?.characters.count == 0 else {
      rightViewMode = .always
      statefulState = validated() ? .success : .fail
      return super.resignFirstResponder()
    }
    statefulState = .fail
    rightViewMode = .whileEditing
    resetPlaceholderLabel()
    return super.resignFirstResponder()
  }
  
  weak var statefulDelegate: StatefulTextFieldDelegate?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  init() {
    super.init(frame: .zero)
    setUp()
  }
  
  private func setUp() {
    borderStyle = .none
    layer.masksToBounds = false
    tintColor = UIColor.easySoftBlue
    delegate = self
    
    layer.addSublayer(lineLayer)
    
    rightView = createClearButton()
    rightViewMode = .whileEditing
    
    addSubview(placeholderLabel)
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: -1, height: 50)
  }
}

// MARK: - Views
fileprivate extension StatefulTextField {
  func createClearButton() -> UIButton {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: StatefulTextField.clearButtonSize, height: StatefulTextField.clearButtonSize))
    button.setImage(UIImage.easyClearButton, for: .normal)
    button.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
    return button
  }
}

// MARK: - Actions
extension StatefulTextField {
  func clearTapped() {
    text = nil
    rightViewMode = .whileEditing
    switch statefulState {
    case .active:
      break
    default:
      statefulState = .inactive
      resetPlaceholderLabel()
    }
  }
}

// MARK: - Private
fileprivate extension StatefulTextField {
  func resetPlaceholderLabel() {
    UIView.animate(withDuration: Constants.defaultAnimationDuration, delay: Constants.defaultAnimationDelay, options: .curveEaseInOut, animations: { [weak self] in
      self?.placeholderLabel.transform = CGAffineTransform.identity
      }, completion: nil)
  }
  
  func fixPlaceholderLabel() {
    UIView.animate(withDuration: Constants.defaultAnimationDuration, delay: Constants.defaultAnimationDelay, options: .curveEaseInOut, animations: { [weak self] in
      self?.placeholderLabel.transform = CGAffineTransform.identity.translatedBy(x: (StatefulTextField.placeholderScaleFactor - 1) / 2 * self!.bounds.width, y: -self!.bounds.height / 2).scaledBy(x: StatefulTextField.placeholderScaleFactor, y: StatefulTextField.placeholderScaleFactor)
      }, completion: nil)
  }
}

// MARK: - Validator
extension StatefulTextField: ValidatorProtocol {
  func validatorType() -> ValidatorType {
    guard let typeField = typeField else {
      return .text
    }
    switch typeField {
    case .text:
      return .text
    case .telNumber:
      return .phone
    case .email:
      return .email
    }
  }
  
  func validatorObject() -> String? {
    return text
  }
}

extension StatefulTextField: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let typeField = typeField, typeField == .telNumber else {
      return true
    }
    let text = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
    let masked = PhoneMask.mask(text: text)
    textField.text = masked
    return false
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text else {
      return
    }
    let trimmedText = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    statefulDelegate?.didEndEditing(with: trimmedText)
  }
}
