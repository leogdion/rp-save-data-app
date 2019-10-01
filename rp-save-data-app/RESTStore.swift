//
//  BackendDatabase.swift
//  rp-save-data-app
//
//  Created by Leo Dion on 10/1/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import Foundation

public struct NotImplementedError : Error {
  
}

public struct RESTStore : RemoteStore {
  public func annotations(_ callback: @escaping (Result<[RPAnnotation], Error>) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 5.0) {
      callback(.success([
        RPAnnotation(id: UUID(), content: "1"),
        RPAnnotation(id: UUID(), content: "2"),
        RPAnnotation(id: UUID(), content: "3"),
        RPAnnotation(id: UUID(), content: "4"),
        RPAnnotation(id: UUID(), content: "5")
      ]))
    }
  }
  
  public func comments(_ callback: @escaping (Result<[RPComment], Error>) -> Void) {
    callback(.failure(NotImplementedError()))
  }
  
  
}
