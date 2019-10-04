//
//  AnnotationsListView.swift
//  rp-save-data-app
//
//  Created by Leo Dion on 10/1/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import SwiftUI

struct AnnotationsListView: View {
  @EnvironmentObject var storeObject : StoreObject
  @State var isBusy = false
  @State var deleteQueue = Set<UUID>()
  var body: some View {
    ZStack{
      annotationsView
      busyView
    }
  }
  
  var busyView : some View {
    isBusy.map().or(self.storeObject.annotations.not()).map{
      ActivityIndicator(isAnimating: .constant(true), style: .large).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center).background(Color.white.opacity(0.5))
      }?.transition(.opacity)
  }
  
  var annotationsView : some View {
    self.storeObject.annotations.flatMap{
      try? $0.get()
    }.map{
      (annotations : [RPAnnotation]) in
      List{
        ForEach(annotations, content: {
          AnnotationRowView(annotation: $0).opacity(self.deleteQueue.contains($0.id) ? 0.5 : 1.0)
        }).onDelete(perform: self.delete)
      }
    }.navigationBarItems(trailing: HStack{
      resetButton
      NavigationLink(destination: AnnotationItemView(editable: true), label: {
        Text("Add")
        }).disabled(isBusy)
      EditButton().disabled(isBusy)
    }).transition(.opacity)
  }
  
  var resetButton : some View {
    self.storeObject.canReset.
  }
  func delete (_ indicies: IndexSet) {
    let annotationsOpt = self.storeObject.annotations.flatMap{ try? $0.get() }
    
    guard let annotations = annotationsOpt else {
      return
    }
    let ids = indicies.map{
      annotations[$0].id
    }
    DispatchQueue.main.async {
      self.deleteQueue.formUnion(ids)
    }
    
    self.isBusy = true
    self.storeObject.delete(annotationsWithIds: ids) {
      error in
      if let error = error {
        
      } else {
        
      }
      DispatchQueue.main.async {
          self.deleteQueue.subtract(ids)
        self.isBusy = false
      }
    }
  }
}


struct AnnotationsListView_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationsListView().environmentObject(StoreObject(store: RESTStore()))
  }
}
