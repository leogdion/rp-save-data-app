//
//  ContentView.swift
//  rp-save-data-app
//
//  Created by Leo Dion on 10/1/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var storeObject : StoreObject
  var body: some View {
    NavigationView{
      AnnotationsListView().navigationBarTitle("Annotations").navigationBarItems(trailing: HStack{
        NavigationLink(destination: AnnotationItemView(editable: true), label: {
          Text("Add")
        })
      })
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(StoreObject(store: RESTStore()))
  }
}
