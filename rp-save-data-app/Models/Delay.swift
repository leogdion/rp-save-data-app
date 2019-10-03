//
//  Delay.swift
//  rp-save-data-app
//
//  Created by Leo Dion on 10/3/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import Foundation

extension DispatchTime {
  static var withDelay : DispatchTime {
    return .now() + Delay.shared.current
  }
}

protocol DelayProtocol {
  var current : TimeInterval {
    get
  }
}

struct Delay : DelayProtocol {
  let range : ClosedRange<TimeInterval>
  static let shared : DelayProtocol = Delay(range: (1...4))
  
  public var current: TimeInterval {
    TimeInterval.random(in: range)
  }
}
