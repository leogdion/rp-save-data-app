import Foundation

struct ErrorData: Identifiable {
  let id: Date
  let message: String
}

protocol ViewableError: Error {
  var data: ErrorData { get }
}

extension Error {
  var data: ErrorData? {
    return (self as? ViewableError)?.data
  }
}
