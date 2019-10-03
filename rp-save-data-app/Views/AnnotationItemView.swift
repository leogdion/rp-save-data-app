//
//  AnnotationItemView.swift
//  rp-save-data-app
//
//  Created by Leo Dion on 10/1/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import SwiftUI



struct AnnotationItemView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @EnvironmentObject var storeObject : StoreObject
  @State var editable : Bool
  @State var annotation = RPAnnotation()
  @State var isBusy = false
  @State var editId : UUID?
  let existing : Bool
  var comments : [RPComment] {
    self.storeObject.comments.flatMap{
      try? $0.get()[self.annotation.id]
    } ?? [RPComment]()
  }
  
  init (annotation : RPAnnotation? = nil, editable : Bool? = nil) {
    self.existing = annotation != nil
    self._editable =  State(initialValue:  editable ?? (annotation == nil))
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
      }?.transition(.opacity)
  }
  
  var readView : some View {
    editable.map(if: false).map { _ in
      VStack(alignment: .leading){
        Spacer(minLength: 10.0)
        Text("Comments (\(self.comments.count))").font(.caption).underline().padding(.leading, 20.0)
        commentsView
      }.navigationBarTitle(annotation.content).navigationBarItems(trailing: HStack{
        Button(action: self.add) {
          Text("Add")
        }.disabled(self.editable)
        Button(action: self.rename){
          Text(self.editable ? "Cancel" : "Rename")
        }
        EditButton().disabled(self.editable)
      }).blur(radius: isBusy ? 5.0 : 0.0)
    }.transition(.opacity)
  }
  
  func rename () {
    self.editable.toggle()
  }
  
  func add () {
    
  }
  
  
  var commentsView : some View {
      List{
        ForEach(comments) {
         comment in
          VStack(alignment: .leading) {
            Text(FormatterProvider.default.string(from: comment.published)).font(.system(.caption))
            Text(comment.content)
          }.onLongPressGesture {
            
          }
          }.onDelete(perform: self.delete)
      }
  }
  
  func delete (_ indicies : IndexSet) {
    let ids = indicies.map{
      comments[$0].id
    }
    self.storeObject.delete(commentsWithIds: ids) {_ in 
      
    }
  }
  
  var editView : some View {
    editable.map { 
      VStack(alignment: .center){
           TextField("Content", text: self.$annotation.content)
             Button(action: saveItem, label: {
               Text("Save")
             })
           }.padding(20)
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
      if (self.existing) {
        self.editable = false
      } else {
        self.presentationMode.wrappedValue.dismiss()
      }
    }
  }
}

struct AnnotationItemView_Previews: PreviewProvider {
  static var previews: some View {
    let store = RESTStore()
    let annotation = store.annotationValues.randomElement()
    return annotation.map { (annotation) in
      AnnotationItemView(annotation: annotation).environmentObject(StoreObject(store: store))
    }
    
  }
}
