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
            ScrollView([.vertical]) {
                VStack(alignment: .center) {
                    HStack {
                        Text(self.event!.summary!)
                            .fontWeight(.bold)
                            .font(.system(size: 20, design: .rounded))
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                            SmallAssetImage(urlName: "",
                                            placeholder: Image("calendar")
                                                .resizable()
                                                .frame(width:25, height:25)
                                                .padding(0))
                    }
                    VStack(alignment: .leading) {
                        Text(DayDateObj.formatter.string(from: ISO8601DateFormatter().date(from: self.event!.start!.dateTime)!) + " - " + DayDateObj.formatter.string(from: ISO8601DateFormatter().date(from: self.event!.end!.dateTime)!))
                                .fontWeight(.light)
                                .font(.system(size: 15))
                        Divider()
                        Text("Created by " + self.event!.creator!.email)
                            .fontWeight(.light)
                            .font(.system(size: 15))
                        Divider()
                        if self.event!.description != nil{
                            Text("Description: " + self.event!.description!)
                                .fontWeight(.light)
                                .font(.system(size: 15))
                        }
                        else{
                            Text("No description available.")
                                .fontWeight(.light)
                                .font(.system(size: 15))
                        }
                    }
                    Divider()
                    NavigationLink(destination: AtendeesView()) {
                        Text("Atendees")
                            .foregroundColor(.yellow)
                    }
                }.frame(maxWidth: geo.size.width, alignment: .leading)
            }
        }.navigationBarTitle("Event")
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
