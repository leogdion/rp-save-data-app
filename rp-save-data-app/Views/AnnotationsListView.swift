import SwiftUI

struct AnnotationsListView: View {
  @EnvironmentObject var storeObject: StoreObject
  @State var isBusy = false
  @State var deleteQueue = Set<Int>()
  @State var errorData: ErrorData?

  var body: some View {
    ZStack {
      errorView
      busyView
      annotationsView
    }.alert(item: $errorData) { (data) -> Alert in
      Alert(title: Text(data.message))
    }
  }

  var errorView: some View {
    self.storeObject.annotations?.error.map {
      Text($0.localizedDescription).padding(20.0)
    }
  }

  var busyView: some View {
    isBusy.map().or(self.storeObject.annotations.not()).map {
      ActivityIndicator(isAnimating: .constant(true), style: .large)
        .frame(
          minWidth: 0,
          maxWidth: .infinity,
          minHeight: 0,
          maxHeight: .infinity,
          alignment: .center
        )
        .background(Color.white.opacity(0.5))
    }?.transition(.opacity)
  }

  var annotationsView: some View {
    self.storeObject.annotations.flatMap {
      try? $0.get()
    }.map {
      (annotations: [RPAnnotation]) in
      List {
        ForEach(annotations, content: {
          AnnotationRowView(annotation: $0).opacity(self.deleteQueue.contains($0.id) ? 0.5 : 1.0)
        }).onDelete(perform: self.delete)
      }
    }.navigationBarItems(trailing: HStack {
      NavigationLink(destination: AnnotationItemView(editable: true), label: {
        Text("Add")
      }).disabled(isBusy)
      EditButton().disabled(isBusy)
    }).transition(.opacity)
  }

  func delete(_ indicies: IndexSet) {
    let annotationsOpt = storeObject.annotations.flatMap { try? $0.get() }

    guard let annotations = annotationsOpt else {
      return
    }
    let ids = indicies.map {
      annotations[$0].id
    }
    DispatchQueue.main.async {
      self.deleteQueue.formUnion(ids)
    }

    isBusy = true
    storeObject.delete(annotationsWithIds: ids) {
      error in
      if let error = error {
        if let data = error.data {
          DispatchQueue.main.async {
            self.errorData = data
            self.isBusy = false
          }
        }
        return
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
