//
//  ContactViewController.swift
//  Easyintest
//
//  Created by Gilson Gil on 20/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

final class ContactViewController: UIViewController {
  fileprivate let tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = UIColor.white
    tableView.separatorStyle = .none
    tableView.estimatedRowHeight = 44
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.keyboardDismissMode = .onDrag
    return tableView
  }()
  
  fileprivate lazy var messageSentView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.isHidden = true
    
    let thankLabel = UILabel()
    thankLabel.textAlignment = .center
    thankLabel.textColor = UIColor.easyGreyish
    thankLabel.text = "Obrigado!"
    thankLabel.font = UIFont.systemFont(ofSize: 14)
    view.addSubview(thankLabel)
    
    let successLabel = UILabel()
    successLabel.numberOfLines = 0
    successLabel.textAlignment = .center
    successLabel.textColor = UIColor.easyAlmostBlack
    successLabel.text = "Mensagem\nenviada\ncom sucesso :)"
    successLabel.font = UIFont.systemFont(ofSize: 28)
    view.addSubview(successLabel)
    
    let resetButton = UIButton()
    resetButton.setTitle("Enviar nova mensagem", for: .normal)
    resetButton.setTitleColor(UIColor.easyDarkSkyBlue, for: .normal)
    view.addSubview(resetButton)
    
    let margin = CGFloat(Constants.defaultMargin)
    constrain(thankLabel, successLabel, resetButton) { thankLabel, successLabel, resetButton in
      successLabel.center == successLabel.superview!.center
      
      thankLabel.centerX == thankLabel.superview!.centerX
      thankLabel.bottom == successLabel.top - margin
      
      resetButton.top == successLabel.bottom + 100
      resetButton.centerX == resetButton.superview!.centerX
    }
    
    return view
  }()
  
  fileprivate var contactViewModel: ContactViewModel? {
    didSet {
      self.tableView.register(self.contactViewModel?.configurators ?? [])
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setUp()
  }
  
  private func setUp() {
    view.addSubview(tableView)
    view.addSubview(messageSentView)
    
    messageSentView.subviews.forEach {
      guard let button = $0 as? UIButton else {
        return
      }
      button.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
    }
    
    constrain(tableView, messageSentView) { tableView, messageSentView in
      tableView.top == tableView.superview!.top
      tableView.left == tableView.superview!.left
      tableView.bottom == tableView.superview!.bottom
      tableView.right == tableView.superview!.right
      
      messageSentView.top == messageSentView.superview!.top
      messageSentView.left == messageSentView.superview!.left
      messageSentView.bottom == messageSentView.superview!.bottom
      messageSentView.right == messageSentView.superview!.right
    }
    
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.title = "Contato"
    DispatchQueue.global().async { [weak self] in
      self?.contactViewModel = ContactViewModel()
    }
    let keyboardHandlerViewController = KeyboardHandlerViewController(scrollView: tableView)
    keyboardHandlerViewController.willMove(toParentViewController: self)
    keyboardHandlerViewController.view.alpha = 0
    keyboardHandlerViewController.view.frame = .zero
    addChildViewController(keyboardHandlerViewController)
    view.addSubview(keyboardHandlerViewController.view)
    keyboardHandlerViewController.didMove(toParentViewController: self)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }
}

// MARK: - Actions
extension ContactViewController {
  func resetTapped() {
    showMessageSent(show: false)
  }
}

// MARK: - Private
fileprivate extension ContactViewController {
  func performSend() {
    contactViewModel?.sendTapped { success in
      guard success else {
        return
      }
      showMessageSent(show: true)
    }
  }
  
  func showMessageSent(show: Bool) {
    if show {
      messageSentView.alpha = 0
      messageSentView.isHidden = false
    }
    UIView.animate(withDuration: Constants.defaultAnimationDuration, delay: Constants.defaultAnimationDelay, options: .curveEaseInOut, animations: {
      self.messageSentView.alpha = show ? 1 : 0
    }, completion: { _ in
      if !show {
        self.messageSentView.isHidden = true
      }
    })
  }
}

// MARK: - UITableView DataSource
extension ContactViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contactViewModel?.configurators.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let contactViewModel = contactViewModel else {
      return UITableViewCell()
    }
    let configurator = contactViewModel.configurators[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: configurator.reuseIdentifier, for: indexPath)
    configurator.update(cell)
    if let checkboxCell = cell as? CheckboxCell {
      checkboxCell.delegate = self
    } else if let textFieldCell = cell as? TextFieldCell {
      textFieldCell.delegate = self
    } else if let sendCell = cell as? SendCell {
      sendCell.delegate = self
    }
    return cell
  }
}

// MARK: - UITableView Delegate
extension ContactViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let selectionCell = tableView.cellForRow(at: indexPath) as? SelectionProtocol {
      defer {
        selectionCell.wasSelected()
      }
    }
  }
}

// MARK: - CheckboxCell Delegate
extension ContactViewController: CheckboxCellDelegate {
  func didChange(checkbox: CheckboxCell, to: Bool) {
    guard let indexPath = tableView.indexPath(for: checkbox) else {
      return
    }
    let cell = contactViewModel?.viewModels[indexPath.row]
    guard let show = cell?.show else {
      return
    }
    guard let newViewModel = contactViewModel?.show(show, show: to), let change = newViewModel.change else {
      return
    }
    tableView.beginUpdates()
    contactViewModel = newViewModel.newViewModel
    if change.insertion {
      let insertionIndexPath = IndexPath(row: change.index, section: 0)
      tableView.insertRows(at: [insertionIndexPath], with: .automatic)
    } else {
      let deletionIndexPath = IndexPath(row: change.index, section: 0)
      tableView.deleteRows(at: [deletionIndexPath], with: .top)
    }
    tableView.endUpdates()
  }
}

// MARK: - TextFieldCell Delegate
extension ContactViewController: TextFieldCellDelegate {
  func didEndEditing(cell: TextFieldCell, with text: String) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    contactViewModel = contactViewModel?.newText(text, at: indexPath.row)
  }
}

// MARK: - SendCell Delegate
extension ContactViewController: SendCellDelegate {
  func sendTapped() {
    performSend()
  }
}
