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

public class RESTStore : RemoteStore {
  
  var annotationValues = [
    RPAnnotation(id: UUID(), content: "1"),
    RPAnnotation(id: UUID(), content: "2"),
    RPAnnotation(id: UUID(), content: "3"),
    RPAnnotation(id: UUID(), content: "4"),
    RPAnnotation(id: UUID(), content: "5")
  ]
  
  public func save(_ annotation: RPAnnotation, _ callback: @escaping (Error?) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 5.0) {
      if let index = self.annotationValues.firstIndex(where: {
        $0.id == annotation.id
      }) {
        self.annotationValues[index] = annotation
      } else {
        self.annotationValues.append(annotation)
      }
      callback(nil)
    }
  }
  
  public func annotations(_ callback: @escaping (Result<[RPAnnotation], Error>) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 5.0) {
      callback(.success(self.annotationValues))
    }
  }
  
  public func comments(_ callback: @escaping (Result<[RPComment], Error>) -> Void) {
    callback(.failure(NotImplementedError()))
  }
  
  
}
