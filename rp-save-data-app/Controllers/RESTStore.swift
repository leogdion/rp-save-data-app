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
      return (UUID(), Date(timeIntervalSinceNow: .random(in: (-2750000...0))))
    }
    
    self.commentValues = annotationIds.flatMap{
      args -> [RPComment] in
      let count = Int.random(in: (7...15))
      let (annotationId, published) = args
      return (1...count).map{
        _ in
        RPComment(id: UUID(), published: faker.date.between(published, Date()), annotationId: annotationId, content: faker.lorem.words(amount: Int.random(in: (2...5))))
      }
    }
    
    self.annotationValues = annotationIds.map{
      RPAnnotation(id: $0.0, content:  faker.lorem.words(amount: Int.random(in: (2...5))), published: $0.1)
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
      callback(.success(self.annotationValues.sorted(by: { $0.published > $1.published})))
    }
  }
  
  public func comments(_ callback: @escaping (Result<[RPComment], Error>) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      callback(.success(self.commentValues))
    }
  }
  
  
}
