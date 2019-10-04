import Foundation

extension Bool {
  func map(if value: Bool = true) -> Void? {
    (self == value) ? Void() : nil
  }

  func map<T>(if _: Bool = true, _ closure: () -> T) -> T? {
    map().map {
      _ in
      closure()
    }
  }
}
