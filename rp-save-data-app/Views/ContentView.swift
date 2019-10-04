import SwiftUI

struct ContentView: View {
  @EnvironmentObject var storeObject: StoreObject
  var body: some View {
    NavigationView {
      AnnotationsListView().navigationBarTitle("Annotations")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(StoreObject(store: RESTStore()))
  }
}
