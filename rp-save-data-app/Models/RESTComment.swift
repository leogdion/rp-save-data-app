import Foundation

struct RESTComment: Codable {
  public let content: String
  public let published: Date
  public let annotationId: Int

  init(_ comment: RPComment) {
    content = comment.content
    published = comment.published
    annotationId = comment.annotationId
  }
}
