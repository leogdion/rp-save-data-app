//
//  StoreObject.swift
//  rp-save-data-app
//
//  Created by Leo Dion on 10/1/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import Foundation

public class StoreObject : ObservableObject {
  let store : RemoteStore
  @Published var annotations : Result<[RPAnnotation], Error>?
  @Published var comments : Result<[UUID : [RPComment]], Error>?
  
  init (store: RemoteStore) {
    self.store = store
    self.store.annotations{
      (annotations) in
      DispatchQueue.main.async {
        self.annotations = annotations
      }
    }
    self.store.comments {
      (comments) in
      DispatchQueue.main.async {
        self.comments = comments.map {
          [UUID : [RPComment]].init(grouping: $0, by: {
            $0.annotationId
          }).mapValues{
            $0.sorted(by: {$0.published > $1.published})
          }
        }
      }
    }
  }
  
  public func beginSave (_ annotation: RPAnnotation, _ callback: @escaping (Error?) -> Void) {
    self.store.save(annotation) { (error) in
      if let error = error {
        callback(error)
        return
      }
      self.store.annotations{
        (annotations) in
        DispatchQueue.main.async {
          self.annotations = annotations
          callback(nil)
        }
      }
    }
  }
  
  public func beginSave (_ comment: RPComment, _ callback: @escaping (Error?) -> Void) {
    self.store.save(comment) { (error) in
      if let error = error {
        callback(error)
        return
      }
     self.store.comments {
        (comments) in
        DispatchQueue.main.async {
          self.comments = comments.map {
            [UUID : [RPComment]].init(grouping: $0, by: {
              $0.annotationId
            }).mapValues{
              $0.sorted(by: {$0.published > $1.published})
            }
          }
          callback(nil)
        }
      }
    }
  }
  
  public func delete(commentsWithIds commentIds: [UUID], _ callback: @escaping (Error?) -> Void) {
    self.store.delete(commentsWithIds: commentIds) {
      error in
      if let error = error {
        self.comments = .failure(error)
        callback(error)
        return
      }
      self.store.comments { (comments) in
        DispatchQueue.main.async {
          self.comments = comments.map {
            [UUID : [RPComment]].init(grouping: $0, by: {
              $0.annotationId
            }).mapValues{
              $0.sorted(by: {$0.published > $1.published})
            }
          }
          callback(nil)
        }
      }
      
    }
  }
  
  public func delete(annotationsWithIds annotationIds: [UUID], _ callback: @escaping (Error?) -> Void) {
    self.store.delete(annotationsWithIds: annotationIds) {
      error in
      if let error = error {
        self.annotations = .failure(error)
        callback(error)
        return
      }
      self.store.annotations { (annotations) in
        DispatchQueue.main.async {
          self.annotations = annotations
          callback(nil)
        }
      }
      
    }
  }
}
