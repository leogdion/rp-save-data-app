//
//  RPAnnotation.swift
//  rp-save-data-app
//
//  Created by Leo Dion on 10/1/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import Foundation

public struct RPAnnotation {
  public let id : UUID
  public let published : Date
  public var content : String
  
  init (id: UUID? = nil, content : String? = nil, published : Date? = nil) {
    self.id = id ?? UUID()
    self.content = content ?? ""
    self.published = published ?? Date()
  }
}

extension RPAnnotation : Identifiable {
  
}
