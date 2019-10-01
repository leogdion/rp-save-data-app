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
          })
        }
      }
    }
    
  }
}
