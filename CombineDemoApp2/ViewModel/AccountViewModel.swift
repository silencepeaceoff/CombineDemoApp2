//
//  AccountViewModel.swift
//  CombineDemoApp2
//
//  Created by Dmitrii Tikhomirov on 6/1/23.
//

import UIKit
import Combine

final class AccountViewModel {

  enum AccountStatus {
    case active
    case banned
  }

  private let warningLimit = 3

  let userAccountStatus = CurrentValueSubject<AccountStatus, Never>(.active)
  let warnings = CurrentValueSubject<Int, Never>(0)

  private var subscriptions = Set<AnyCancellable>()

  init() {
    createSubscription()
  }

  func increaseWarning() {
    warnings.value += 1
    print("Warning: \(warnings.value)")
  }
}

private extension AccountViewModel {

  func createSubscription() {
    warnings.filter({ [weak self] val in
      guard let self = self else { return false}
      return val >= self.warningLimit
    })
    .sink { [weak self] _ in
      guard let self = self else { return }
      self.userAccountStatus.value = .banned
    }
    .store(in: &subscriptions)
  }
}
