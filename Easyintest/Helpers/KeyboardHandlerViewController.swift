//
//  KeyboardHandlerViewController.swift
//
//  Created by Gilson Gil on 2/19/16.
//  Copyright © 2016 Gilson Gil. All rights reserved.
//

import UIKit

protocol KeyboardHandlerViewControllerDelegate: class {
  func keyboardDidAppear(height: CGFloat)
  func keyboardDidDisapper()
}

final class KeyboardHandlerViewController: UIViewController {
  private let scrollView: UIScrollView?
  private var originalContentInset = UIEdgeInsets.zero
  
  weak var delegate: KeyboardHandlerViewControllerDelegate?
  
  required init?(coder aDecoder: NSCoder) {
    scrollView = nil
    super.init(coder: aDecoder)
  }
  
  init(scrollView: UIScrollView?) {
    self.scrollView = scrollView
    originalContentInset = scrollView?.contentInset ?? .zero
    super.init(nibName: nil, bundle: nil)
    view.alpha = 0
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(KeyboardHandlerViewController.keyboardAppeared), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(KeyboardHandlerViewController.keyboardDisappeared), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  func keyboardAppeared(notification: Notification) {
    guard let keyboardRectValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
      return
    }
    delegate?.keyboardDidAppear(height: keyboardRectValue.cgRectValue.height)
    guard let scrollView = scrollView else {
      return
    }
    let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: 0, bottom: keyboardRectValue.cgRectValue.height, right: 0)
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
    scrollView.addGestureRecognizer(tap)
  }
  
  func keyboardDisappeared(notification: NSNotification) {
    delegate?.keyboardDidDisapper()
    guard let scrollView = scrollView else {
      return
    }
    scrollView.gestureRecognizers?.forEach {
      guard let tap = $0 as? UITapGestureRecognizer else {
        return
      }
      scrollView.removeGestureRecognizer(tap)
    }
    UIView.animate(withDuration: Constants.defaultAnimationDuration, delay: Constants.defaultAnimationDelay, options: .curveEaseInOut, animations: { [weak self] in
      scrollView.contentInset = self?.originalContentInset ?? .zero
      scrollView.scrollIndicatorInsets = self?.originalContentInset ?? .zero
      }, completion: nil)
  }
  
  func tapped() {
    scrollView?.endEditing(true)
  }
  
  #if DEBUG
  deinit {
    print("deinit", self)
  }
  #endif
}
