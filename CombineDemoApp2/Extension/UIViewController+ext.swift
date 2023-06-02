//
//  UIViewController+ext.swift
//  CombineDemoApp2
//
//  Created by Dmitrii Tikhomirov on 6/1/23.
//

import UIKit

extension UIViewController {

  func showBlocked() {

    let alert = UIAlertController(title: "Ooops", message: "Throught you were tough right? Well guess what you're ban", preferredStyle: .alert)

    self.present(alert, animated: true)
  }
}
