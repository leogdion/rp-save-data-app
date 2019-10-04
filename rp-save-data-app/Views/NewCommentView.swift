//
//  NewCommentView.swift
//  rp-save-data-app
//
//  Created by Leo Dion on 10/4/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import SwiftUI

struct NewCommentView: View {
    @EnvironmentObject var storeObject : StoreObject
    @State var comment : RPComment
    
    var body: some View {
      VStack{
        TextField("Content", text: $comment.content)
        HStack{
          Button("Cancel", action: self.cancel)
          Button("Add", action: self.add)
        }
      }
    }
    
    func add () {
      
    }
    
    func cancel () {
      
    }
}

struct NewCommentView_Previews: PreviewProvider {
    static var previews: some View {
      NewCommentView(comment: RPComment(id: UUID(), published: Date(), annotationId: UUID(), content: ""))
    }
}
