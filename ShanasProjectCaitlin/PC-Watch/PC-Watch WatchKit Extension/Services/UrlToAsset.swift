//
//  UrlToAsset.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 7/20/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation
import SwiftUI

struct AssetImage<Placeholder: View>: View {
    let urlName: String
    private let placeholder: Placeholder?
    
    init(urlName: String, placeholder: Placeholder? = nil) {
        self.urlName = urlName
        self.placeholder = placeholder
    }

    var body: some View {
        image
    }
    
    private var image: some View {
        Group {
            if photoUrlToAssetImage[urlName] != nil {
                Circle()
                    .foregroundColor(Color.yellow.opacity(0.9))
                    .frame(width: 60, height: 60)
                    .overlay(Image(photoUrlToAssetImage[urlName]!)
                        .resizable()
                        .frame(width:35, height:35)
                        .padding(0))
                    .overlay(Circle().stroke(Color.red, lineWidth: 1))
                    .shadow(color: .yellow , radius: 4)
                    .padding(EdgeInsets(top: 8, leading: 2, bottom: 0, trailing: 2))
            } else {
                Circle()
                    .foregroundColor(Color.yellow.opacity(0.9))
                    .frame(width: 60, height: 60)
                    .overlay(placeholder)
                    .overlay(Circle().stroke(Color.red, lineWidth: 1))
                    .shadow(color: .yellow , radius: 4)
                    .padding(EdgeInsets(top: 8, leading: 2, bottom: 0, trailing: 2))
            }
        }
    }
}

struct SmallAssetImage<Placeholder: View>: View {
    let urlName: String
    private let placeholder: Placeholder?
    
    init(urlName: String, placeholder: Placeholder? = nil) {
        self.urlName = urlName
        self.placeholder = placeholder
    }

    var body: some View {
        smallImage
    }
    
    private var smallImage: some View {
        Group {
            if photoUrlToAssetImage[urlName] != nil && photoUrlToAssetImage[urlName] != "" {
                Circle()
                    .foregroundColor(Color.yellow.opacity(0.9))
                    .frame(width: 30, height: 30)
                    .overlay(Image(photoUrlToAssetImage[urlName]!)
                        .resizable()
                        .frame(width:22, height:22)
                        .padding(0))
                    .overlay(Circle().stroke(Color.red, lineWidth: 1))
                    .shadow(color: .yellow , radius: 4)
                    .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 2))
            } else {
                Circle()
                    .foregroundColor(Color.yellow.opacity(0.9))
                    .frame(width: 30, height: 30)
                    .overlay(placeholder)
                    .overlay(Circle().stroke(Color.red, lineWidth: 1))
                    .shadow(color: .yellow , radius: 4)
                    .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 2))
            }
        }
    }
}
