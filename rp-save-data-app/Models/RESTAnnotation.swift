import Foundation

struct RESTAnnotation: Codable {
  public let content: String
  public let published: Date

  init(_ annotation: RPAnnotation) {
    content = annotation.content
    published = annotation.published
  }
}
