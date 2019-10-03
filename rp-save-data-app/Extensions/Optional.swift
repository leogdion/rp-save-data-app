//
//  Optional.swift
//  rp-save-data-app
//
//  Created by Leo Dion on 10/3/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import Foundation

extension Optional {
  func and<T> (_ other : Optional<T>) -> Optional<(Wrapped, T)> {
    switch (self,other) {
    case (.some(let mine), .some(let another)):
      return (mine, another)
    default:
      return nil
    }
  }
  
  func not<T> (_ closure: () -> T) -> Optional<T> {
    switch self {
    case .none:
      return closure()
    default:
      return nil
    }
  }
}
