//
//  EventsView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/24/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct EventsView: View {
    @ObservedObject private var model = FirebaseGoogleService.shared
    var event: Event?
      
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center){
                Text(self.event!.summary!)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                    //SmallAssetImage(urlName: "", placeholder: Image("calendar"))
                Circle()
                    .foregroundColor(Color.yellow.opacity(0.9))
                    .frame(width: 40, height: 40)
                    .overlay(Image("calendar")
                        .resizable()
                        .frame(width:25, height:25)
                        .padding(0))
                    .overlay(Circle().stroke(Color.red, lineWidth: 1))
                    .shadow(color: .yellow , radius: 4)
                    .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 2))
                
                VStack{
                    Text("Created by: " + self.event!.creator!.email)
                    if self.event!.description != nil{
                        Text("Description: " + self.event!.description!)
                    }
                    else{
                        Text("No description available.")
                    }
                }
            }.frame(maxWidth: geo.size.width, alignment: .leading)
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
