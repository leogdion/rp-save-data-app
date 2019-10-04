import Fakery
import Foundation

public class RESTStore: RemoteStore {
  let jsonDecoder: JSONDecoder = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(formatter)
    return decoder
  }()

  let jsonEncoder: JSONEncoder = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(formatter)
    return encoder
  }()

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
}
