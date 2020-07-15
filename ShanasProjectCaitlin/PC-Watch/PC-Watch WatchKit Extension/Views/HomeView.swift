//
//  HomeView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/6/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI
import UIKit

struct TaskCompleteImage: View {
    var isComplete: Bool
    var hasTasks: Bool
    
    var body : some View {
        ZStack {
            VStack(alignment: .center) {
                if (self.isComplete) {
                    Image(systemName: "checkmark.circle")
                        .font(.subheadline)
                        .imageScale(.large)
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "circle")
                        .font(.subheadline)
                        .imageScale(.large)
                }
                Spacer()
                if (hasTasks) {
                    Image(systemName: "plus.circle")
                        .font(.subheadline)
                        .imageScale(.small)
                        .accentColor(.white)
                }
            }
        }
    }
}

struct infoView: View {
    var item: Value?
    
    let timeLeft: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        formatter.timeZone = .current
        print(formatter.timeZone!)
        return formatter
    }()

    let formatter: DateFormatter = {
        let formatter1 = DateFormatter()
        formatter1.timeZone = .current
        formatter1.dateFormat = "h:mm a"
        return formatter1
    }()
//    var name: String?
//    var time: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.item!.mapValue.fields.title.stringValue).fontWeight(.bold).font(.system(size: 20))
            Spacer()
            Text(self.formatter.string(from: self.timeLeft.date(from: self.item!.mapValue.fields.startDayAndTime.stringValue)!)  + " - " + self.formatter.string(from: self.timeLeft.date(from: self.item!.mapValue.fields.endDayAndTime.stringValue)!)).fontWeight(.light).font(.system(size: 15))
        }
    }
}

struct HomeView: View {
    //TODO: need to have a list containing all the objects: events, goals, routines
    // issue: can we display events in same list if in different models?
    
    // below has goals and routines
    @ObservedObject private var model = FirebaseServices.shared
    
    // below has events
//    @ObservedObject private var eventModel = FirebaseServ
    
    var body: some View {

        GeometryReader { geo in
            if (self.model.data == nil){
                VStack(alignment: .leading) {
                    Text("You dont have anything on your schedule!")
                    Spacer()
                }
            }
            else {
                VStack(alignment: .leading) {
                    List {
                        ForEach(self.model.data!, id: \.mapValue.fields.id.stringValue) { item in
                            NavigationLink(destination: TasksView(itemID: item.mapValue.fields.id.stringValue, time: self.formatter.string(from: self.timeLeft.date(from: item.mapValue.fields.startDayAndTime.stringValue)!)  + " - " + self.formatter.string(from: self.timeLeft.date(from: item.mapValue.fields.endDayAndTime.stringValue)!), name: item.mapValue.fields.title.stringValue)){
                                HStack {
                                    infoView(item: item)
                                    Spacer()
                                    
                                    //TODO: set isComplete and hasTasks to actual values
                                    TaskCompleteImage(isComplete: true, hasTasks: true).padding(EdgeInsets(top: 8, leading: 0, bottom: 2, trailing: 0))
                                }.frame(height: 80).padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 0))
                            }.listRowPlatterColor(item.mapValue.fields.isPersistent.booleanValue ? Color.gray : Color.yellow.opacity(0.75))
                        }
                    }.listStyle(CarouselListStyle()).navigationBarTitle("My Day")
                }.padding(0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
