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
  
  var body: some View {
    ZStack{
      busyView
      annotationsView
    }
  }
  
  var busyView : some View {
    self.storeObject.annotations.not{
      ActivityIndicator(isAnimating: .constant(true), style: .large)
    }
  }
  
  var annotationsView : some View {
    self.storeObject.annotations.flatMap{
      try? $0.get()
    }.map{
      (annotations : [RPAnnotation]) in
      List(annotations, rowContent: AnnotationRowView.init)
    }
  }
}

struct AnnotationRowView : View {
  let annotation : RPAnnotation
  var body: some View {
    NavigationLink(destination: destination, label: {
      Text(annotation.content)
    })
  }
  
  var destination : some View {
    AnnotationItemView(annotation: self.annotation)
  }
}

struct AnnotationsListView_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationsListView().environmentObject(StoreObject(store: RESTStore()))
  }
}
