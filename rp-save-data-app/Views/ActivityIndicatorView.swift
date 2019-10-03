//
//  ActivityIndicatorView.swift
//  rp-save-data-app
//
//  Created by Leo Dion on 10/1/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import SwiftUI
import UIKit

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

