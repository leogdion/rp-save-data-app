import Fakery
import Foundation

public class CloudStore: RemoteStore {
  public func save(_ comment: RPComment, _ callback: @escaping (Error?) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      if let index = self.commentValues.firstIndex(where: { $0.id == comment.id }) {
        self.commentValues[index] = comment
      } else {
        let nextId = (self.commentValues.map{ $0.id }.max() ?? 0) + 1
        let newComment = RPComment(
          annotationId: comment.annotationId,
          id: nextId,
          published: Date(), content: comment.content)
        self.commentValues.append(newComment)
      }
      callback(nil)
    }
  }

  public func delete(annotationsWithIds annotationIds: [Int], _ callback: @escaping (Error?) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      self.annotationValues = self.annotationValues.filter {
        !annotationIds.contains($0.id)
      }
      callback(nil)
    }
  }

  public func delete(commentsWithIds commentIds: [Int], _ callback: @escaping (Error?) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      self.commentValues = self.commentValues.filter {
        !commentIds.contains($0.id)
      }
      callback(nil)
    }
  }

  var annotationValues: [RPAnnotation]
  var commentValues: [RPComment]

  init() {
    let faker = Faker()
    let count = Int.random(in: 7 ... 15)
    let annotationIdDates = (1 ... count).map { id in
      (id, Date(timeIntervalSinceNow: .random(in: -2_750_000 ... 0)))
    }

    commentValues = annotationIdDates.flatMap {
      args -> [RPComment] in
      let count = Int.random(in: 7 ... 15)
      let (annotationId, published) = args
      return (1 ... count).map {
        _ in
        RPComment(annotationId: annotationId, id: faker.number.increasingUniqueId(), published: faker.date.between(published, Date()), content: faker.lorem.words(amount: Int.random(in: 2 ... 5)))
      }
    }

    annotationValues = annotationIdDates.map {
      RPAnnotation(id: $0.0, content: faker.lorem.words(amount: Int.random(in: 2 ... 5)), published: $0.1)
    }
  }

  public func save(_ annotation: RPAnnotation, _ callback: @escaping (Error?) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      if let index = self.annotationValues.firstIndex(where: {
        $0.id == annotation.id
      }) {
        self.annotationValues[index] = annotation
      } else {
        let nextId = (self.annotationValues.map{ $0.id }.max() ?? 0) + 1
        let newAnnotation = RPAnnotation(id: nextId, content: annotation.content)
        self.annotationValues.append(newAnnotation)
      }
      callback(nil)
    }
  }

  public func annotations(_ callback: @escaping (Result<[RPAnnotation], Error>) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      callback(.success(self.annotationValues.sorted(by: { $0.published > $1.published })))
    }
  }

  public func comments(_ callback: @escaping (Result<[RPComment], Error>) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      callback(.success(self.commentValues))
    }
  }
}
