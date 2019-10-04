import Fakery
import Foundation

public class RESTStore: RemoteStore {
  public func save(_: RPComment, _ callback: @escaping (Error?) -> Void) {
    callback(NotImplementedError())
  }

  public func delete(annotationsWithIds _: [UUID], _ callback: @escaping (Error?) -> Void) {
    callback(NotImplementedError())
  }

  public func delete(commentsWithIds _: [UUID], _ callback: @escaping (Error?) -> Void) {
    callback(NotImplementedError())
  }

  public func save(_: RPAnnotation, _ callback: @escaping (Error?) -> Void) {
    callback(NotImplementedError())
  }

  public func annotations(_ callback: @escaping (Result<[RPAnnotation], Error>) -> Void) {
    callback(.failure(NotImplementedError()))
  }

  public func comments(_ callback: @escaping (Result<[RPComment], Error>) -> Void) {
    callback(.failure(NotImplementedError()))
  }
}
