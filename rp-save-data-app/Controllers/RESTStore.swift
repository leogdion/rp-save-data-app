//
//  BackendDatabase.swift
//  rp-save-data-app
//
//  Created by Leo Dion on 10/1/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import Foundation
import Fakery

public struct NotImplementedError : Error {
  
}

public class RESTStore : RemoteStore {
  
  public func delete(annotationsWithIds annotationIds: [UUID], _ callback: @escaping (Error?) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      self.annotationValues = self.annotationValues.filter{
        !annotationIds.contains($0.id)
       }
       callback(nil)
    }
  }
  public func delete(commentsWithIds commentIds: [UUID], _ callback: @escaping (Error?) -> Void) {
    
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      self.commentValues = self.commentValues.filter{
        !commentIds.contains($0.id)
      }
      callback(nil)
    }
  }
  
  
  
  
  var annotationValues : [RPAnnotation]
  var commentValues : [RPComment]
  
  init () {
    let faker = Faker()
    let count = Int.random(in: (7...15))
    let annotationIds = (1...count).map{_ in
      return UUID()
    }
    
    self.commentValues = annotationIds.flatMap{
      annotationId -> [RPComment] in
      let count = Int.random(in: (7...15))
      return (1...count).map{
        _ in
        RPComment(id: UUID(), annotationId: annotationId, content: faker.lorem.words(amount: Int.random(in: (2...5))))
      }
    }
    
    self.annotationValues = annotationIds.map{
      RPAnnotation(id: $0, content:  faker.lorem.words(amount: Int.random(in: (2...5))))
    }
  }
  
  public func save(_ annotation: RPAnnotation, _ callback: @escaping (Error?) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
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
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      callback(.success(self.annotationValues))
    }
  }
  
  public func comments(_ callback: @escaping (Result<[RPComment], Error>) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      callback(.success(self.commentValues))
    }
  }
  
  
}
