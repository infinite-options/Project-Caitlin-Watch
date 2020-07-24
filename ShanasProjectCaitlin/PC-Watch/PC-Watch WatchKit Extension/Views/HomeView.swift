//
//  HomeView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/6/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI
import UIKit

let durationFormatter: DateFormatter = {
    let format = DateFormatter()
    format.timeZone = .current
    format.dateFormat = "h:mm"
    return format
}()

struct itemImage: View {
    var photo: String
    var isComplete: Bool
    var isInProgress: Bool
    
    var body: some View {
        HStack {
            if (isComplete == true){
                SmallAssetImage(urlName: photo, placeholder: Image("default-goal"))
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.40)
                    .overlay(Image(systemName: "checkmark.circle")
                        .font(.system(size:44))
                        .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                        .foregroundColor(.green))
            } else if (isInProgress == true) {
                SmallAssetImage(urlName: photo, placeholder: Image("default-goal"))
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.40)
                    .overlay(Image(systemName: "arrow.2.circlepath.circle")
                        .font(.system(size:44))
                        .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                        .foregroundColor(.yellow))
            } else {
                SmallAssetImage(urlName: photo, placeholder: Image("default-goal"))
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}
struct EventInfoView: View {
    var item: Event?
    @ObservedObject private var model = FirebaseGoogleService.shared
    
    var body: some View{
        VStack(alignment: .leading){
            Text(self.item!.summary!)
                .fontWeight(.bold)
                .font(.system(size: 20))
                .lineLimit(2)
            Spacer()
            HStack{
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
                
                VStack(alignment: .leading) {
                    Text("Starts: " + DayDateObj.formatter.string(from: ISO8601DateFormatter().date(from: self.item!.start!.dateTime)!))
                        .fontWeight(.light)
                        .font(.system(size: 15))
                        
                    Text("Ends: " + DayDateObj.formatter.string(from: ISO8601DateFormatter().date(from: self.item!.end!.dateTime)!))
                        .fontWeight(.light)
                        .font(.system(size: 15))
                }
            }
        }
    }
}
struct infoView: View {
    var item: Value?
    @ObservedObject private var model = FirebaseGoogleService.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(self.item!.mapValue!.fields.title.stringValue).fontWeight(.bold).font(.system(size: 20))
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
    //TODO: need to have a list containing all the objects: events, goals, routines
    // issue: can we display events in same list if in different models?
    
    // below has goals and routines
    @ObservedObject private var model = FirebaseGoogleService.shared
    
    
    //@ObservedObject private var modelTest = UserDay.shared
//    @State var showTasks: Bool = false
    
    // below has events
    // @ObservedObject private var eventModel = FirebaseServ
    var body: some View {

        GeometryReader { geo in
            if (self.model.UserDay.count == 0){
                VStack(alignment: .leading) {
                    Text("You dont have anything on your schedule!")
                    Spacer()
                }
            }
            else {
                VStack(alignment: .leading) {
                    List {
                        //ForEach(Array(self.model.data!.filter{ $0.mapValue!.fields.isDisplayedToday.booleanValue == true }.enumerated()), id: \.offset) { index, item in
                        ForEach(Array(self.model.UserDay.enumerated()), id: \.offset) { index, item in
                            VStack(alignment: .leading) {
                            if self.isGoalOrEvent(item: item){
                                NavigationLink (destination: EventsView(event: (item as! Event))){
                                    EventInfoView(item: (item as! Event))
                                //Text(item.summary!)
                                //Text(item.start!.dateTime)
                                }.frame(height: 80)
                                .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 0))
                            }
                            else{
                                NavigationLink(destination: TasksView(goalOrRoutine: (item as! Value), goalOrRoutineIndex: index)) {
                                HStack {
                                    infoView(item: (item as! Value))
                                }.frame(height: 80)
                                    .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 0))
                            }
                            }
                            }.listRowPlatterColor((item is Event) ? Color.blue.opacity(0.75) : item.mapValue!.fields.isPersistent.booleanValue ? Color.gray : Color.yellow.opacity(0.75))
                        }
                    }.listStyle(CarouselListStyle()).navigationBarTitle("My Day")
                }.padding(0)
            }
        }
    }
    
    private func isGoalOrEvent(item: UserDayGoalEventList) -> Bool{
        if item is Event {
            return true
        }
        else { return false }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
