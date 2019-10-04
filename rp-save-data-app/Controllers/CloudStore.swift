import Fakery
import Foundation

public class CloudStore: RemoteStore {
  public func save(_ comment: RPComment, _ callback: @escaping (Error?) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      if let index = self.commentValues.firstIndex(where: { $0.id == comment.id }) {
        self.commentValues[index] = comment
      } else {
        self.commentValues.append(comment)
      }
      callback(nil)
    }
  }

  public func delete(annotationsWithIds annotationIds: [UUID], _ callback: @escaping (Error?) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .withDelay) {
      self.annotationValues = self.annotationValues.filter {
        !annotationIds.contains($0.id)
      }
      callback(nil)
    }
  }

  public func delete(commentsWithIds commentIds: [UUID], _ callback: @escaping (Error?) -> Void) {
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
    let annotationIds = (1 ... count).map { _ in
      (UUID(), Date(timeIntervalSinceNow: .random(in: -2_750_000 ... 0)))
    }

    commentValues = annotationIds.flatMap {
      args -> [RPComment] in
      let count = Int.random(in: 7 ... 15)
      let (annotationId, published) = args
      return (1 ... count).map {
        _ in
        RPComment(id: UUID(), published: faker.date.between(published, Date()), annotationId: annotationId, content: faker.lorem.words(amount: Int.random(in: 2 ... 5)))
      }
    }

    annotationValues = annotationIds.map {
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
        self.annotationValues.append(annotation)
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
