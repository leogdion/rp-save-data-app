import SwiftUI

struct NewCommentView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @EnvironmentObject var storeObject: StoreObject
  @State var comment: RPComment
  @State var isBusy = false

  var body: some View {
    ZStack {
      busyView
      VStack(alignment: .center) {
        TextField("Content", text: $comment.content).disabled(isBusy)
        HStack {
          Button("Cancel", action: self.cancel).disabled(isBusy)
          Button("Add", action: self.add).disabled(self.isBusy)
        }
      }.padding(20.0).blur(radius: self.isBusy ? 2.0 : 0.0)
    }
  }

  var busyView: some View {
    isBusy.map {
      ActivityIndicator(isAnimating: $isBusy, style: .large)
    }
  }

  func add() {
    isBusy = true
    storeObject.beginSave(comment) { _ in
      self.presentationMode.wrappedValue.dismiss()
    }
  }

  func cancel() {
    presentationMode.wrappedValue.dismiss()
  }
}

struct NewCommentView_Previews: PreviewProvider {
  static var previews: some View {
    NewCommentView(comment: RPComment(id: UUID(), published: Date(), annotationId: UUID(), content: ""))
  }
}
