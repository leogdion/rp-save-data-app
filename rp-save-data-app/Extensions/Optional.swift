import Foundation

extension Optional {
  func or<T>(_ other: T?) -> Void? {
    switch (self, other) {
    case (.none, .none):
      return nil
    default:
      return Void()
    }
  }

  func and<T>(_ other: T?) -> (Wrapped, T)? {
    switch (self, other) {
    case let (.some(mine), .some(another)):
      return (mine, another)
    default:
      return nil
    }
  }

  func not<T>(_ closure: () -> T) -> T? {
    switch self {
    case .none:
      return closure()
    default:
      return nil
    }
  }

  func not() -> Void? {
    switch self {
    case .none:
      return Void()
    default:
      return nil
    }
  }
}

extension Result {
  var error: Failure? {
    if case let .failure(error) = self {
      return error
    } else {
      return nil
    }
  }
}
