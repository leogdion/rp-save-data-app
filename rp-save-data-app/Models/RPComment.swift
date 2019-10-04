//
//  RPComment.swift
//  rp-save-data-app
//
//  Created by Leo Dion on 10/1/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import Foundation

public struct RPComment {
  public let id : UUID
  public let published : Date
  public let annotationId : UUID
  public var content : String
}

extension RPComment : Identifiable {
  
}
