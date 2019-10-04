import Foundation

public struct RPAnnotation {
  public let id: Int
  public let published: Date
  public var content: String

  init(id _: Int? = nil, content: String? = nil, published: Date? = nil) {
    id = -1
    self.content = content ?? ""
    self.published = published ?? Date()
  }
}

extension RPAnnotation: Identifiable {}

extension RPAnnotation: Codable {}

extension RPAnnotation {
  var isNew: Bool {
    return id <= 0
  }
}
