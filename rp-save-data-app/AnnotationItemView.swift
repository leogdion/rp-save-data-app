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
  
  func not<T> (_ closure: () -> T) -> Optional<T> {
    switch self {
    case .none:
      return closure()
    default:
      return nil
    }
  }
}

extension Bool {
  func map(if value: Bool = true) -> Void? {
    return (self == value) ? Void() : nil
  }
  
  func map<T>(if value: Bool = true, _ closure: () -> T) -> T? {
    
    return self.map().map{
      _ in
      closure()
    }
  }
}

struct AnnotationItemView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @EnvironmentObject var storeObject : StoreObject
  let editable : Bool
  @State var annotation = RPAnnotation()
  @State var isBusy = false
  
  init (annotation : RPAnnotation? = nil, editable : Bool? = nil) {
    
    self.editable =  editable ?? (annotation == nil)
    self._annotation = State(initialValue: (annotation ?? RPAnnotation()))
  }
  
  var body: some View {
    ZStack{
      readView
      editView
      busyView
    }
  }
  
  var busyView : some View {
    return isBusy.map(){
      ActivityIndicator(isAnimating: $isBusy, style: .large)
    }
  }
  
  var readView : some View {
    editable.map(if: false).and(isBusy.map(if: false)).map { _ in
      Text(self.annotation.content)
    }
  }
  
  var editView : some View {
    editable.map().and(isBusy.map(if: false)).map {  _ in
      VStack{
      TextField("Content", text: self.$annotation.content)
        Button(action: saveItem, label: {
          Text("Save")
        })
      }
    }
  }
  
  func saveItem () {
    self.isBusy = true
    self.storeObject.beginSave(self.annotation) {
      (error) in
      self.isBusy = false
      if let error = error {
        return
      }
      self.presentationMode.wrappedValue.dismiss()
    }
  }
}

struct AnnotationItemView_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationItemView()
  }
}
