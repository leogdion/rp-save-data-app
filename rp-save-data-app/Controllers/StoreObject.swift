import Foundation

/// `ObservableObject`  to share across the Application with the `RemoteStore`.
public class StoreObject: ObservableObject {
  /// `RemoteStore` to share
  let store: RemoteStore

  /// All the annotation results
  @Published var annotations: Result<[RPAnnotation], Error>?
  /// All the comments results mapped to annotations
  @Published var comments: Result<[Int: [RPComment]], Error>?

  /// Creates a `StoreObject` with the designated `RemoteStore`
  /// - Parameter store: `RemoteStore` implmentation
  init(store: RemoteStore) {
    self.store = store
    self.store.annotations {
      annotations in
      DispatchQueue.main.async {
        self.annotations = annotations
      }
    }
    self.store.comments {
      comments in
      DispatchQueue.main.async {
        self.comments = comments.map {
          [Int: [RPComment]].init(grouping: $0, by: {
            $0.annotationId
          }).mapValues {
            $0.sorted(by: { $0.published > $1.published })
          }
        }
      }
    }
  }

  /// Saves the annotation to the data set
  /// - Parameter annotation: The updated or new annotation
  /// - Parameter callback: Callback for the completed save.
  public func beginSave(_ annotation: RPAnnotation, _ callback: @escaping (Error?) -> Void) {
    store.save(annotation) { error in
      if let error = error {
        callback(error)
        return
      }
      self.store.annotations {
        annotations in
        DispatchQueue.main.async {
          self.annotations = annotations
          callback(nil)
        }
      }
    }
  }

  /// Saves the comment to the data set
  /// - Parameter annotation: The updated or new comment
  /// - Parameter callback: Callback for the completed save.
  public func beginSave(_ comment: RPComment, _ callback: @escaping (Error?) -> Void) {
    store.save(comment) { error in
      if let error = error {
        callback(error)
        return
      }
      self.store.comments {
        comments in
        DispatchQueue.main.async {
          self.comments = comments.map {
            [Int: [RPComment]].init(grouping: $0, by: {
              $0.annotationId
            }).mapValues {
              $0.sorted(by: { $0.published > $1.published })
            }
          }
          callback(nil)
        }
      }
    }
  }

  /// Deletes the comments baed on the ids passed.
  /// - Parameter commentIds: Array of comment Ids.
  /// - Parameter callback: Callback for the completed deletes.
  public func delete(commentsWithIds commentIds: [Int], _ callback: @escaping (Error?) -> Void) {
    store.delete(commentsWithIds: commentIds) {
      error in
      if let error = error {
        self.comments = .failure(error)
        callback(error)
        return
      }
      self.store.comments { comments in
        DispatchQueue.main.async {
          self.comments = comments.map {
            [Int: [RPComment]].init(grouping: $0, by: {
              $0.annotationId
            }).mapValues {
              $0.sorted(by: { $0.published > $1.published })
            }
          }
          callback(nil)
        }
      }
    }
  }

  /// Deletes the annotations based on the ids passed.
  /// - Parameter commentIds: Array of annotation Ids.
  /// - Parameter callback: Callback for the completed deletes.
  public func delete(annotationsWithIds annotationIds: [Int], _ callback: @escaping (Error?) -> Void) {
    store.delete(annotationsWithIds: annotationIds) {
      error in
      if let error = error {
        self.annotations = .failure(error)
        callback(error)
        return
      }
      self.store.annotations { annotations in
        DispatchQueue.main.async {
          self.annotations = annotations
          callback(nil)
        }
      }
    }
  }
}
