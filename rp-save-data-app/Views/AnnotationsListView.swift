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
  
  var body: some View {
    ZStack{
      busyView
      annotationsView
    }
  }
  
  var busyView : some View {
    isBusy.map().or(self.storeObject.annotations.not()).map{
      ActivityIndicator(isAnimating: .constant(true), style: .large)
    }
  }
  
  var annotationsView : some View {
    self.storeObject.annotations.flatMap{
      try? $0.get()
    }.map{
      (annotations : [RPAnnotation]) in
      //List(annotations, rowContent: AnnotationRowView.init)
      List{
        ForEach(annotations, content: AnnotationRowView.init).onDelete(perform: self.delete)
      }
    }.navigationBarItems(trailing: HStack{
      NavigationLink(destination: AnnotationItemView(editable: true), label: {
        Text("Add")
      })
      EditButton()
    })
  }
  
  func delete (_ indicies: IndexSet) {
    let annotationsOpt = self.storeObject.annotations.flatMap{ try? $0.get() }
    
    guard let annotations = annotationsOpt else {
      return
    }
    let ids = indicies.map{
      annotations[$0].id
    }
    self.isBusy = true
    self.storeObject.delete(annotationsWithIds: ids) {_ in 
      self.isBusy = false
    }
  }
}


struct AnnotationsListView_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationsListView().environmentObject(StoreObject(store: RESTStore()))
  }
}
