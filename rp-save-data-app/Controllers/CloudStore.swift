import Fakery
import Foundation

/// _Cloud_ Store implementation of `RemoteStore`
public class CloudStore: RemoteStore {
  /// Collection of Cloud Data
  struct CloudDataset {
    /// Array of Annotations
    var annotations: [RPAnnotation]
    /// Array of Comments
    var comments: [RPComment]

    init() {
      let faker = Faker()
      let count = Int.random(in: 7 ... 15)
      let annotationIdDates = (1 ... count).map { id in
        (id, Date(timeIntervalSinceNow: .random(in: -2_750_000 ... 0)))
      }

      comments = annotationIdDates.flatMap {
        args -> [RPComment] in
        let count = Int.random(in: 7 ... 15)
        let (annotationId, published) = args
        return (1 ... count).map {
          _ in
          RPComment(
            annotationId: annotationId,
            id: faker.number.increasingUniqueId(),
            published: faker.date.between(published, Date()),
            content: faker.lorem.words(amount: Int.random(in: 2 ... 5))
          )
        }
      }

      annotations = annotationIdDates.map {
        RPAnnotation(id: $0.0, content: faker.lorem.words(amount: Int.random(in: 2 ... 5)), published: $0.1)
      }
    }
  }

  /// Data set used by `RemoteStore`
  var dataset = CloudDataset()

  /// Gets  all annotations
  /// - Parameter callback: Callback for when the call is competed.
  public func annotations(_ callback: @escaping (Result<[RPAnnotation], Error>) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      callback(.success(self.dataset.annotations.sorted(by: { $0.published > $1.published })))
    }
  }

  /// Gets all comments
  /// - Parameter callback: Callback for when the call is completed.
  public func comments(_ callback: @escaping (Result<[RPComment], Error>) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      callback(.success(self.dataset.comments))
    }
  }

  /// Saves a new annotation or updates the annotation.
  /// - Parameter annotation: The new or updated annotation.
  /// - Parameter callback: Callback for when the save is completed.
  public func save(_ annotation: RPAnnotation, _ callback: @escaping (Error?) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      if let index = self.dataset.annotations.firstIndex(where: {
        $0.id == annotation.id
      }) {
        self.dataset.annotations[index] = annotation
      } else {
        let nextId = (self.dataset.annotations.map { $0.id }.max() ?? 0) + 1
        let newAnnotation = RPAnnotation(id: nextId, content: annotation.content)
        self.dataset.annotations.append(newAnnotation)
      }
      callback(nil)
    }
  }

  /// Saves a new comment or updates the comment.
  /// - Parameter comment: The new or updated comment.
  /// - Parameter callback: Callback for when the save is completed.
  public func save(_ comment: RPComment, _ callback: @escaping (Error?) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      if let index = self.dataset.comments.firstIndex(where: { $0.id == comment.id }) {
        self.dataset.comments[index] = comment
      } else {
        let nextId = (self.dataset.comments.map { $0.id }.max() ?? 0) + 1
        let newComment = RPComment(
          annotationId: comment.annotationId,
          id: nextId,
          published: Date(), content: comment.content
        )
        self.dataset.comments.append(newComment)
      }
      callback(nil)
    }
  }

  /// Deletes the annotations by ids.
  /// - Parameter annotationIds: Array of annotation ids.
  /// - Parameter callback: Callback for when the deletes are completed.
  public func delete(annotationsWithIds annotationIds: [Int], _ callback: @escaping (Error?) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      self.dataset.annotations = self.dataset.annotations.filter {
        !annotationIds.contains($0.id)
      }
      callback(nil)
    }
  }

  /// Deletes the comments by ids.
  /// - Parameter commentIds: Array of comment ids.
  /// - Parameter callback: Callback for when the deletes are completed.
  public func delete(commentsWithIds commentIds: [Int], _ callback: @escaping (Error?) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      self.dataset.comments = self.dataset.comments.filter {
        !commentIds.contains($0.id)
      }
      callback(nil)
    }
  }
}
