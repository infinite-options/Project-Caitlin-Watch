//
//  AsyncImage.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/11/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    
    init(url: URL, placeholder: Placeholder? = nil) {
        loader = ImageLoader(url: url)
        self.placeholder = placeholder
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
            Group {
                if loader.image != nil {
                    Image(uiImage: loader.image!)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 0.5))
                        .shadow(radius: 10)
                        .padding(EdgeInsets(top: 10, leading: -1, bottom: 10, trailing: 1.5))
                } else {
                    placeholder 
            }
        }
    }
}

//struct AsyncImage_Previews: PreviewProvider {
//    static var previews: some View {
//        AsyncImage()
//    }
//}
