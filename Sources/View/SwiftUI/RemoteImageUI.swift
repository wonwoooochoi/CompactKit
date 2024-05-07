//
//  RemoteImageUI.swift
//
//
//  Created by Wonwoo Choi on 5/7/24.
//

import SwiftUI
import Kingfisher

public struct RemoteImageUI: View {
    private let urlString: String
    
    public init(_ urlString: String) {
        self.urlString = urlString
    }
    
    public var body: some View {
        if !urlString.isEmpty,
           let url = URL(string: urlString) {
            KFImage(url)
                .resizable()
                .cancelOnDisappear(true)
        }
        else {
            EmptyView()
        }
    }
}

#Preview {
    RemoteImageUI("https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/logo.png")
}
