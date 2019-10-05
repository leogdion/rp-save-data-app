import Fakery
import Foundation

/// REST Store for RemoteStore
public class RESTStore: RemoteStore {
  /// JSONDecoder for Data Models
  let jsonDecoder: JSONDecoder = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(formatter)
    return decoder
  }()

  /// JSONDecoder for Data Models
  let jsonEncoder: JSONEncoder = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(formatter)
    return encoder
  }()

  /// Gets  all annotations
  /// - Parameter callback: Callback for when the call is competed.
  public func annotations(_ callback: @escaping (Result<[RPAnnotation], Error>) -> Void) {
    let url = URL(string: "https://cumbersome-base.glitch.me/annotations?_sort=published&_order=desc")!
    URLSession.shared.dataTask(with: url) {
      let result = Result(success: $0, error: $2, defaultError: EmptyResultError()).flatMap {
        data in
        Result(catching: {
          try self.jsonDecoder.decode([RPAnnotation].self, from: data)
        })
      }
      callback(result)
    }.resume()
  }

  /// Gets all comments
  /// - Parameter callback: Callback for when the call is completed.
  public func comments(_ callback: @escaping (Result<[RPComment], Error>) -> Void) {
    let url = URL(string: "https://cumbersome-base.glitch.me/comments?_sort=published&_order=desc")!
    URLSession.shared.dataTask(with: url) {
      let result = Result(success: $0, error: $2, defaultError: EmptyResultError()).flatMap {
        data in
        Result(catching: {
          try self.jsonDecoder.decode([RPComment].self, from: data)
        })
      }
      callback(result)
    }.resume()
  }

  /// Saves a new annotation or updates the annotation.
  /// - Parameter annotation: The new or updated annotation.
  /// - Parameter callback: Callback for when the save is completed.
  public func save(_ annotation: RPAnnotation, _ callback: @escaping (Error?) -> Void) {
    let url: URL
    if annotation.isNew == true {
      url = URL(string: "https://cumbersome-base.glitch.me/annotations")!
    } else {
      url = URL(string: "https://cumbersome-base.glitch.me/annotations/\(annotation.id)")!
    }
    let passedData = RESTAnnotation(annotation)
    var request = URLRequest(url: url)

    if annotation.isNew == true {
      request.httpMethod = "POST"
    } else {
      request.httpMethod = "PUT"
    }
    do {
      request.httpBody = try jsonEncoder.encode(passedData)
    } catch {
      callback(error)
      return
    }
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    URLSession.shared.dataTask(with: request) {
      callback($2)
    }.resume()
  }

  /// Saves a new comment or updates the comment.
  /// - Parameter comment: The new or updated comment.
  /// - Parameter callback: Callback for when the save is completed.
  public func save(_ comment: RPComment, _ callback: @escaping (Error?) -> Void) {
    let url: URL
    if comment.isNew == true {
      url = URL(string: "https://cumbersome-base.glitch.me/comments")!
    } else {
      url = URL(string: "https://cumbersome-base.glitch.me/comments/\(comment.id)")!
    }
    let passedData = RESTComment(comment)
    var request = URLRequest(url: url)

    if comment.isNew == true {
      request.httpMethod = "POST"
    } else {
      request.httpMethod = "PUT"
    }
    do {
      request.httpBody = try jsonEncoder.encode(passedData)
    } catch {
      callback(error)
      return
    }
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    URLSession.shared.dataTask(with: request) {
      callback($2)
    }.resume()
  }

  /// Deletes the comments by ids.
  /// - Parameter commentIds: Array of comment ids.
  /// - Parameter callback: Callback for when the deletes are completed.
  public func delete(annotationsWithIds annotationIds: [Int], _ callback: @escaping (Error?) -> Void) {
    let requests: [URLRequest] = annotationIds.map {
      id in
      let url = URL(string: "https://cumbersome-base.glitch.me/annotations/\(id)")!
      var request = URLRequest(url: url)
      request.httpMethod = "DELETE"
      return request
    }

    let group = DispatchGroup()
    var errors = [Error]()
    for request in requests {
      group.enter()
      URLSession.shared.dataTask(with: request) { _, _, error in
        DispatchQueue.global().async(group: nil, qos: .default, flags: .barrier) {
          if let error = error {
            errors.append(error)
          }
          group.leave()
        }
      }.resume()
    }

    group.notify(queue: .global()) {
      callback(errors.first)
    }
  }

  /// Deletes the annotations by ids.
  /// - Parameter commentIds: Array of annotation ids.
  /// - Parameter callback: Callback for when the deletes are completed.
  public func delete(commentsWithIds commentIds: [Int], _ callback: @escaping (Error?) -> Void) {
    let requests: [URLRequest] = commentIds.map {
      id in
      let url = URL(string: "https://cumbersome-base.glitch.me/comments/\(id)")!
      var request = URLRequest(url: url)
      request.httpMethod = "DELETE"
      return request
    }

    let group = DispatchGroup()
    var errors = [Error]()
    for request in requests {
      group.enter()
      URLSession.shared.dataTask(with: request) { _, _, error in
        DispatchQueue.global().async(group: nil, qos: .default, flags: .barrier) {
          if let error = error {
            errors.append(error)
          }
          group.leave()
        }
      }.resume()
    }

    group.notify(queue: .global()) {
      callback(errors.first)
    }
  }
}
