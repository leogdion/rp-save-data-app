import Foundation

public protocol RemoteStore {
  // MARK: List Methods

  func annotations(_ callback: @escaping (Result<[RPAnnotation], Error>) -> Void)
  func comments(_ callback: @escaping (Result<[RPComment], Error>) -> Void)

  // MARK: Upsert (Create or Replace) Methods

  func save(_ annotation: RPAnnotation, _ callback: @escaping (Error?) -> Void)
  func save(_ comment: RPComment, _ callback: @escaping (Error?) -> Void)

  // MARK: Delete Methods

  func delete(commentsWithIds commentIds: [UUID], _ callback: @escaping (Error?) -> Void)
  func delete(annotationsWithIds annotationIds: [UUID], _ callback: @escaping (Error?) -> Void)
}
