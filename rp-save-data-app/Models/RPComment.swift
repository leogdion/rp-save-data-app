import Foundation

public struct RPComment {
  public let id: Int
  public let published: Date
  public let annotationId: Int
  public var content: String

  init(
    annotationId: Int, id _: Int? = nil,
    published _: Date? = nil,
    content _: String? = nil
  ) {
    self.annotationId = annotationId
    id = -1
    published = Date()
    content = ""
  }
}

extension RPComment: Identifiable {}

extension RPComment: Codable {}

extension RPComment {
  var isNew: Bool {
    return id <= 0
  }
}
