import Foundation

/// Protocol for Remote Store
public protocol RemoteStore {
  // MARK: List Methods

  /// Gets  all annotations
  /// - Parameter callback: Callback for when the call is competed.
  func annotations(_ callback: @escaping (Result<[RPAnnotation], Error>) -> Void)

  /// Gets all comments
  /// - Parameter callback: Callback for when the call is completed.
  func comments(_ callback: @escaping (Result<[RPComment], Error>) -> Void)

  // MARK: Upsert (Create or Replace) Methods

  /// Saves a new annotation or updates the annotation.
  /// - Parameter annotation: The new or updated annotation.
  /// - Parameter callback: Callback for when the save is completed.
  func save(_ annotation: RPAnnotation, _ callback: @escaping (Error?) -> Void)

  /// Saves a new comment or updates the comment.
  /// - Parameter comment: The new or updated comment.
  /// - Parameter callback: Callback for when the save is completed.
  func save(_ comment: RPComment, _ callback: @escaping (Error?) -> Void)

  // MARK: Delete Methods

  /// Deletes the comments by ids.
  /// - Parameter commentIds: Array of comment ids.
  /// - Parameter callback: Callback for when the deletes are completed.
  func delete(commentsWithIds commentIds: [Int], _ callback: @escaping (Error?) -> Void)

  /// Deletes the annotations by ids.
  /// - Parameter annotationIds: Array of annotation ids.
  /// - Parameter callback: Callback for when the deletes are completed.
  func delete(annotationsWithIds annotationIds: [Int], _ callback: @escaping (Error?) -> Void)
}
