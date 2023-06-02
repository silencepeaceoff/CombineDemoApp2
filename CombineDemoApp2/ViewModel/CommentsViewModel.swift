//
//  CommentsViewModel.swift
//  CombineDemoApp2
//
//  Created by Dmitrii Tikhomirov on 6/1/23.
//

import UIKit
import Combine

final class CommentsViewModel {

  private let commentEntered = PassthroughSubject<String, Never>()
  private var subscriptions = Set<AnyCancellable>()

  private let badWords = ["💩", "🍆"]

  private let manager: AccountViewModel

  init(manager: AccountViewModel) {
    self.manager = manager
    setupSubscriptions()
  }

  func send(comment: String) {
    commentEntered.send(comment)
  }

}

private extension CommentsViewModel {

  func setupSubscriptions() {

    commentEntered
      .filter { !$0.isEmpty }
      .sink { [weak self] val in
        guard let self = self else { return }

        if self.badWords.contains(val) {
          manager.increaseWarning()
        } else {
          print("New comment: \(val)")
        }

    }
    .store(in: &subscriptions)
  }
}
