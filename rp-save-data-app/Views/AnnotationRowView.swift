import SwiftUI

struct AnnotationRowView: View {
  let annotation: RPAnnotation
  var body: some View {
    NavigationLink(destination: destination, label: {
      VStack(alignment: .leading) {
        Text(FormatterProvider.default.string(from: annotation.published)).font(.system(.caption))
        Text(annotation.content)
      }
    })
  }

  var destination: some View {
    AnnotationItemView(annotation: self.annotation)
  }
}
