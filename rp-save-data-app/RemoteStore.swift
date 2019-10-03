//
//  RemoteStore.swift
//  rp-save-data-app
//
//  Created by Leo Dion on 10/1/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import Foundation

public protocol RemoteStore {
  func annotations (_ callback: @escaping (Result<[RPAnnotation], Error>) -> Void)
  func comments (_ callback: @escaping (Result<[RPComment], Error>) -> Void)
  
  func save(_ annotation: RPAnnotation, _ callback: @escaping (Error?) -> Void)
  func delete(commentsWithIds commentIds: [UUID], _ callback: @escaping (Error?) -> Void)
}
