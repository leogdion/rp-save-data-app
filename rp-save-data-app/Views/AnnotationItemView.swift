import SwiftUI

struct AnnotationItemView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @Environment(\.editMode) var editMode
  @EnvironmentObject var storeObject: StoreObject
  @State var editable: Bool
  @State var annotation = RPAnnotation()
  @State var isBusy = false
  @State var deleteQueue = Set<Int>()
  @State var newComment: RPComment?
  @State var editId: Int? {
    didSet {
      if let comment = self.editId.flatMap({ id in self.comments.first { $0.id == id } }) {
        editContent = comment.content
      } else {
        editContent = ""
      }
    }
  }

  @State var editContent: String = ""
  let existing: Bool

  var comments: [RPComment] {
    storeObject.comments.flatMap {
      try? $0.get()[self.annotation.id]
    } ?? [RPComment]()
  }

  init(annotation: RPAnnotation? = nil, editable: Bool? = nil) {
    existing = annotation != nil
    _editable = State(initialValue: editable ?? (annotation == nil))
    _annotation = State(initialValue: annotation ?? RPAnnotation())
  }

  var body: some View {
    ZStack {
      readView
      editView
      busyView
    }.sheet(item: $newComment, content: {
      NewCommentView(comment: $0).environmentObject(self.storeObject)
    })
  }

  var busyView: some View {
    return isBusy.map {
      ActivityIndicator(isAnimating: $isBusy, style: .large).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center).background(Color.white.opacity(0.5))
    }?.transition(.opacity)
  }

  var readView: some View {
    editable.map(if: false).map { _ in
      VStack(alignment: .leading) {
        Spacer(minLength: 10.0)
        Text("Comments (\(self.comments.count))").font(.caption).underline().padding(.leading, 20.0)
        commentsView
      }.navigationBarTitle(annotation.content).navigationBarItems(trailing: HStack {
        Button(action: self.add) {
          Text("Add")
        }.disabled(self.editable)
        Button(action: self.rename) {
          Text(self.editable ? "Cancel" : "Rename")
        }
        EditButton().disabled(self.editable)
      }).blur(radius: isBusy ? 5.0 : 0.0)
    }.transition(.opacity)
  }

  func rename() {
    editable.toggle()
  }

  func add() {
    newComment = RPComment(annotationId: annotation.id)
  }

  var commentsView: some View {
    List {
      ForEach(comments) {
        comment in
        VStack(alignment: .leading) {
          self.row(forComment: comment)
        }
      }.onDelete(perform: self.delete)
    }
  }

  @ViewBuilder
  func row(forComment comment: RPComment) -> some View {
    VStack(alignment: .leading) {
      Text(FormatterProvider.default.string(from: comment.published)).font(.system(.caption))
      if comment.id == self.editId {
        HStack {
          TextField("content", text: self.$editContent)
          Spacer()
          Button(action: self.commitEdit, label: {
            Text("Done").padding([.horizontal], 5.0)
          })
        }
      } else {
        readRow(forComment: comment)
      }
    }.opacity(deleteQueue.contains(comment.id) ? 0.5 : 1.0)
  }

  func readRow(forComment comment: RPComment) -> some View {
    HStack {
      Text(comment.content)
      Spacer()
    }.onTapGesture {
      if self.editMode?.wrappedValue == .inactive {
        self.editId = comment.id
      }
    }
  }

  func commitEdit() {
    let commentOpt = comments.first {
      $0.id == self.editId
    }
    guard var comment = commentOpt else {
      editId = nil
      return
    }
    comment.content = editContent
    isBusy = true
    storeObject.beginSave(comment) { error in
      if let error = error {
        self.editId = nil
        self.isBusy = false
        return
      }
      self.editId = nil
      self.isBusy = false
    }
  }

  func delete(_ indicies: IndexSet) {
    let ids = indicies.map {
      comments[$0].id
    }
    DispatchQueue.main.async {
      self.deleteQueue.formUnion(ids)
      self.isBusy = true
    }
    storeObject.delete(commentsWithIds: ids) { _ in

      DispatchQueue.main.async {
        self.deleteQueue.subtract(ids)
        self.isBusy = false
      }
    }
  }

  var editView: some View {
    editable.map {
      VStack(alignment: .center) {
        TextField("Content", text: self.$annotation.content)
        Button(action: saveItem, label: {
          Text("Save")
        })
      }.padding(20)
    }
  }

  func saveItem() {
    isBusy = true
    storeObject.beginSave(annotation) {
      error in
      self.isBusy = false
      if let error = error {
        return
      }
      if self.existing {
        self.editable = false
      } else {
        self.presentationMode.wrappedValue.dismiss()
      }
    }
  }
}
