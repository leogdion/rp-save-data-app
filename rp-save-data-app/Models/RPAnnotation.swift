import Foundation

public struct RPAnnotation {
  public let id: UUID
  public let published: Date
  public var content: String

  init(id: UUID? = nil, content: String? = nil, published: Date? = nil) {
    self.id = id ?? UUID()
    self.content = content ?? ""
    self.published = published ?? Date()
  }
}

extension RPAnnotation: Identifiable {}
