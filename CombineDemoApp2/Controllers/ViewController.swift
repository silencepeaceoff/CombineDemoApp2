//
//  ViewController.swift
//  CombineDemoApp2
//
//  Created by Dmitrii Tikhomirov on 6/1/23.
//

import UIKit
import Combine

class ViewController: UIViewController {

  private let commentTxtVw: UITextView = {
    let textVw = UITextView()
    textVw.layer.borderColor = UIColor.systemGray4.cgColor
    textVw.layer.borderWidth = 1
    textVw.layer.cornerRadius = 8
    textVw.translatesAutoresizingMaskIntoConstraints = false
    return textVw
  }()

  private let commentBtn: UIButton = {
    let btn = UIButton()
    btn.setTitle("Comment", for: .normal)
    btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
    btn.setTitleColor(.white, for: .normal)
    btn.backgroundColor = .systemBlue
    btn.layer.cornerRadius = 8
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.addTarget(self, action: #selector(commentDidTouch), for: .touchUpInside)
    return btn
  }()

  private let formContainerStackVw: UIStackView = {
    let stackVw = UIStackView()
    stackVw.spacing = 16
    stackVw.axis = .vertical
    stackVw.distribution = .fillProportionally
    stackVw.translatesAutoresizingMaskIntoConstraints = false
    return stackVw
  }()

  private lazy var accountViewModel = AccountViewModel()
  private lazy var commentViewModel = CommentsViewModel(manager: accountViewModel)

  private var subscriptions = Set<AnyCancellable>()

  override func loadView() {
    super.loadView()

    setup()
    accountSubscription()
  }

  @objc func commentDidTouch() {
    commentViewModel.send(comment: commentTxtVw.text)
  }

}

private extension ViewController {

  func setup() {
    view.backgroundColor = .systemBackground

    formContainerStackVw.addArrangedSubview(commentTxtVw)
    formContainerStackVw.addArrangedSubview(commentBtn)
    view.addSubview(formContainerStackVw)

    NSLayoutConstraint.activate([
      commentBtn.heightAnchor.constraint(equalToConstant: 44),
      commentTxtVw.heightAnchor.constraint(equalToConstant: 150),

      formContainerStackVw.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      formContainerStackVw.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      formContainerStackVw.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])
  }

  func accountSubscription() {

    accountViewModel
      .userAccountStatus
      .sink { [weak self] status in
        guard let self = self else { return }
        if status == .banned {
          self.showBlocked()
        }
      }
      .store(in: &subscriptions)
  }
}
