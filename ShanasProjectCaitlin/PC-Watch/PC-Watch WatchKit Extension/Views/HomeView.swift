//
//  HomeView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/6/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI
import UIKit

struct EventInfoView: View {
    var item: Event?
    
    var body: some View{
        VStack(alignment: .leading){
            Text(self.item!.summary!)
                .fontWeight(.bold)
                .font(.system(size: 20, design: .rounded))
                .lineLimit(2)
            Spacer()
            HStack{
                if self.isNow(item: item!) {
                    SmallAssetImage(urlName: "",
                                placeholder: Image("calendar")
                                    .resizable()
                                    .frame(width:25, height:25)
                                    .padding(0))
                } else {
                    SmallAssetImage(urlName: "",
                                placeholder: Image("calendar")
                                    .resizable()
                                    .frame(width:25, height:25)
                                    .padding(0))
                        .opacity(0.40)
                        .overlay(Image(systemName: "checkmark.circle")
                            .font(.system(size:44))
                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                            .foregroundColor(.green))
                }
                
                VStack(alignment: .leading) {
                    Text("Start " + DayDateObj.formatter.string(from: ISO8601DateFormatter().date(from: self.item!.start!.dateTime)!))
                        .fontWeight(.light)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.system(size: 15))
                        
                    Text("End " + DayDateObj.formatter.string(from: ISO8601DateFormatter().date(from: self.item!.end!.dateTime)!))
                        .fontWeight(.light)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.system(size: 15))
                }
            }
        }
    }
    
    private func isNow(item: Event) -> Bool {
        if DayDateObj.ISOFormatter.date(from: item.end!.dateTime)! < Date() {
            return false
        }
        return true
    }
}

struct infoView: View {
    //TODO: doesnt update complete until reload the app because passed by value
    var item: Value?
    @ObservedObject private var model = FirebaseGoogleService.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(self.item!.mapValue!.fields.title.stringValue)
                    .fontWeight(.bold)
                    .font(.system(size: 20, design: .rounded))
                Spacer()
                if (!(self.model.goalsSubtasks[item!.mapValue!.fields.id.stringValue] == nil)) {
                    Image(systemName: "plus.circle")
                        .font(.subheadline)
                        .imageScale(.small)
                        .accentColor(.white)
                }
            }
            Spacer()
            HStack {
                if ((self.item!.mapValue!.fields.isComplete?.booleanValue) == true){
                    SmallAssetImage(urlName: self.item!.mapValue!.fields.photo.stringValue, placeholder: Image("default-goal"))
                        .aspectRatio(contentMode: .fit)
                        .opacity(0.40)
                        .overlay(Image(systemName: "checkmark.circle")
                            .font(.system(size:44))
                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                            .foregroundColor(.green))
                } else if (self.item!.mapValue!.fields.isInProgress?.booleanValue == true) {
                    SmallAssetImage(urlName: self.item!.mapValue!.fields.photo.stringValue, placeholder: Image("default-goal"))
                        .aspectRatio(contentMode: .fit)
                        .opacity(0.40)
                        .overlay(Image(systemName: "arrow.2.circlepath.circle")
                            .font(.system(size:44))
                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                            .foregroundColor(.yellow))
                } else {
                    SmallAssetImage(urlName: self.item!.mapValue!.fields.photo.stringValue, placeholder: Image("default-goal"))
                        .aspectRatio(contentMode: .fit)
                }
                //Text(formatter.string(from: timeLeft.date(from: self.item!.mapValue.fields.startDayAndTime.stringValue)!)  + " - " + formatter.string(from: timeLeft.date(from: self.item!.mapValue.fields.endDayAndTime.stringValue)!)).fontWeight(.light).font(.system(size: 15))
                VStack(alignment: .leading) {
                    Text("Takes " + self.item!.mapValue!.fields.expectedCompletionTime.stringValue).fontWeight(.light).font(.system(size: 15))
                    Text("Ends: " + DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: self.item!.mapValue!.fields.endDayAndTime.stringValue)!)).fontWeight(.light).font(.system(size: 15))
                }
            }
        }
    }
}

struct HomeView: View {
    // below has goals and routines
    @ObservedObject private var model = UserDay.shared
    
    @State var fullDay = false
    @State var showLess = true
    
    var body: some View {

        GeometryReader { geo in
            if(self.model.isUserSignedIn != .signedIn){
                VStack(alignment: .center) {
                    Text("Please sign in to view your day!")
                    .fontWeight(.bold)
                    .font(.system(size: 20, design: .rounded))
                    Spacer()
                }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                .navigationBarTitle(self.model.navBar)
            }
            else if (self.model.UserDayData.count == 0){
                VStack(alignment: .center) {
                    Text("You dont have anything on your schedule!")
                    .fontWeight(.bold)
                    .font(.system(size: 20, design: .rounded))
                    Spacer()
                }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                .navigationBarTitle(self.model.navBar)
            }
            else {
                VStack {
                    if (self.fullDay) {
                        VStack(alignment: .leading) {
                            List {
                                ForEach(Array(self.model.UserDayData.enumerated()), id: \.offset) { index, item in
                                    VStack(alignment: .leading) {
                                        if self.isEvent(item: item) {
                                            NavigationLink (destination: EventsView(event: (item as! Event))){
                                                EventInfoView(item: (item as! Event))
                                            }.frame(height: 80)
                                            .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 0))
                                        }
                                        else {
                                            NavigationLink(destination: TasksView(goalOrRoutine: (item as! Value), goalOrRoutineIndex: index, fullDayArray: true)) {
                                            HStack {
                                                infoView(item: (item as! Value))
                                            }.frame(height: 80)
                                                .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 0))
                                            }
                                        }
                                    }.listRowPlatterColor((item is Event) ? Color.yellow.opacity(0.75) : (item.mapValue!.fields.isPersistent.booleanValue ? Color.gray : Color(Color.RGBColorSpace.sRGB, red: 0.68, green: 0.68, blue: 0.68, opacity: 0.3)))
                                }
                                Button(action: {
                                    self.fullDay = false
                                    self.showLess = true
                                }) {
                                    Text("Show less")
                                        .foregroundColor(.yellow)
                                        .frame(maxWidth: geo.size.width, alignment: .center)
                                }
                            }.listStyle(CarouselListStyle())
                                .navigationBarTitle(self.model.navBar)
                        }.padding(0)
                    }
                    if self.showLess {
                        VStack(alignment: .leading) {
                            List {
                                ForEach(Array(self.model.UserDayBlockData.enumerated()), id: \.offset) { index, item in
                                    VStack(alignment: .leading) {
                                        if self.isEvent(item: item) {
                                            NavigationLink (destination: EventsView(event: (item as! Event))){
                                                EventInfoView(item: (item as! Event))
                                            }.frame(height: 80)
                                            .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 0))
                                        }
                                        else {
                                            NavigationLink(destination: TasksView(goalOrRoutine: (item as! Value), goalOrRoutineIndex: index, fullDayArray: false)) {
                                            HStack {
                                                infoView(item: (item as! Value))
                                            }.frame(height: 80)
                                                .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 0))
                                            }
                                        }
                                    }.listRowPlatterColor((item is Event) ? Color.yellow.opacity(0.75) : (item.mapValue!.fields.isPersistent.booleanValue ? Color.gray : Color(Color.RGBColorSpace.sRGB, red: 0.68, green: 0.68, blue: 0.68, opacity: 0.3)))
                                }
                                Button(action: {
                                    self.fullDay = true
                                    self.showLess = false
                                }) {
                                    Text("Show full day")
                                        .foregroundColor(.yellow)
                                }
                            }.listStyle(CarouselListStyle())
                                .navigationBarTitle(self.model.navBar)
                        }.padding(0)
                    }
                }.navigationBarTitle(self.model.navBar)
            }
        }
    }
    
    private func isEvent(item: UserDayGoalEventList) -> Bool{
        if item is Event {
            return true
        } else {
            return false
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
