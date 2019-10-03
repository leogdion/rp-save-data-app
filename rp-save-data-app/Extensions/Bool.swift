//
//  Bool.swift
//  rp-save-data-app
//
//  Created by Leo Dion on 10/3/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import Foundation

extension Bool {
  func map(if value: Bool = true) -> Void? {
    (self == value) ? Void() : nil
  }
  
  func map<T>(if value: Bool = true, _ closure: () -> T) -> T? {
    self.map().map{
      _ in
      closure()
    }
  }
}
