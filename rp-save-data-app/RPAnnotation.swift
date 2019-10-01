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
  public var content : String
  
  init (id: UUID? = nil, content : String? = nil) {
    self.id = id ?? UUID()
    self.content = content ?? ""
  }
}

extension RPAnnotation : Identifiable {
  
}
