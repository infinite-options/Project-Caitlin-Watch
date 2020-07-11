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
                Circle()
                    .foregroundColor(Color.yellow.opacity(0.9))
                    .frame(width: 60, height: 60)
                    .overlay(Image(uiImage: loader.image!)
                        .resizable()
                        .frame(width:35, height:35)
                        .padding(0))
                    .overlay(Circle().stroke(Color.red, lineWidth: 1))
                    .shadow(color: .yellow , radius: 4)
                    .padding(EdgeInsets(top: 8, leading: 2, bottom: 0, trailing: 2))
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
