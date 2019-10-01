//
//  AnnotationItemView.swift
//  rp-save-data-app
//
//  Created by Leo Dion on 10/1/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import SwiftUI

enum AnnotationItemViewMode {
  case new, edit(UUID), read(UUID)
  
  init (id: UUID?, editable: Bool?) {
    if let id = id {
      if editable == true {
        self = .edit(id)
      } else {
        self = .read(id)
      }
    } else {
      self = .new
    }
  }
  
  var id : UUID? {
    switch self {
    case .edit(let id):
      return id
    case .read(let id):
      return id
    default:
      return nil
    }
  }
}

extension Optional {
  func and<T> (_ other : Optional<T>) -> Optional<(Wrapped, T)> {
    switch (self,other) {
    case (.some(let mine), .some(let another)):
      return (mine, another)
    default:
      return nil
    }
  }
}

struct AnnotationItemView: View {
  @EnvironmentObject var storeObject : StoreObject
  let editable : Bool
  @State var annotation = RPAnnotation()
  
  
  init (annotation : RPAnnotation? = nil, editable : Bool? = nil) {
    self.editable = editable ?? (annotation == nil)
    self.annotation = annotation ?? RPAnnotation()
  }
  
  var body: some View {
    ZStack{
      editView
    }
  }
  
  var editView : some View {
    let doView : Void?
    
    if editable {
      doView = Void()
    } else {
      doView = nil
    }
    
    return doView.map{
      _ in
      VStack{
      TextField("Content", text: self.$annotation.content)
        Button(action: saveItem, label: {
          Text("Save")
        })
      }
    }
  }
  
  func saveItem () {
    self.storeObject.beginSave(self.annotation) {
      (error) in
      if let error = error {
        return
      }
      
    }
  }
}

struct AnnotationItemView_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationItemView()
  }
}
