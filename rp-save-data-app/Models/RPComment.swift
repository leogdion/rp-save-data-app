import Foundation

public struct RPComment {
  public let id: UUID
  public let published: Date
  public let annotationId: UUID
  public var content: String
}

extension RPComment: Identifiable {}
