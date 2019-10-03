//
//  DateFormatter.swift
//  rp-save-data-app
//
//  Created by Leo Dion on 10/3/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import Foundation

protocol DateFormatterProvider {
  var formatter : DateFormatter { get }
}

struct FormatterProvider : DateFormatterProvider {
  public let formatter: DateFormatter =  {
    let formatter = Foundation.DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    return formatter
  }()
}

extension DateFormatterProvider {
  static var `default` : DateFormatterProvider {
    return FormatterProvider()
  }
  func string (from date: Date) -> String {
    self.formatter.string(from: date)
  }
}
