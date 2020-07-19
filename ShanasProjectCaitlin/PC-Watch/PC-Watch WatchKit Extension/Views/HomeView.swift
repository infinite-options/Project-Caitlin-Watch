//
//  HomeView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/6/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI
import UIKit

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

let durationFormatter: DateFormatter = {
    let format = DateFormatter()
    format.timeZone = .current
    format.dateFormat = "h:mm"
    return format
}()

struct infoView: View {
    var item: Value?
    @ObservedObject private var model = FirebaseServices.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(self.item!.mapValue.fields.title.stringValue).fontWeight(.bold).font(.system(size: 20))
                Spacer()
                if (!(self.model.goalsSubtasks[item!.mapValue.fields.id.stringValue] == nil)) {
                    Image(systemName: "plus.circle")
                        .font(.subheadline)
                        .imageScale(.small)
                        .accentColor(.white)
                }
            }
            Spacer()
            HStack {
                if ((self.item!.mapValue.fields.isComplete?.booleanValue) == true){
                    AsyncSmallImage(url: URL(string:self.item!.mapValue.fields.photo.stringValue)!, placeholder: Image("")).aspectRatio(contentMode: .fit).opacity(0.40)
                        .overlay(Image(systemName: "checkmark.circle")
                            .font(.system(size:44))
                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                            .foregroundColor(.green))
                } else if (self.item!.mapValue.fields.isInProgress?.booleanValue == true) {
                    AsyncSmallImage(url: URL(string:self.item!.mapValue.fields.photo.stringValue)!, placeholder: Image("")).aspectRatio(contentMode: .fit)
                        .opacity(0.40)
                        .overlay(Image(systemName: "arrow.2.circlepath.circle")
                            .font(.system(size:44))
                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                            .foregroundColor(.yellow))
                } else {
                    AsyncSmallImage(url: URL(string:self.item!.mapValue.fields.photo.stringValue)!, placeholder: Image("")).aspectRatio(contentMode: .fit)
                }
                //Text(formatter.string(from: timeLeft.date(from: self.item!.mapValue.fields.startDayAndTime.stringValue)!)  + " - " + formatter.string(from: timeLeft.date(from: self.item!.mapValue.fields.endDayAndTime.stringValue)!)).fontWeight(.light).font(.system(size: 15))
                VStack(alignment: .leading) {
                    Text("Takes " + self.item!.mapValue.fields.expectedCompletionTime.stringValue).fontWeight(.light).font(.system(size: 15))
                    Text("Ends: " + formatter.string(from: timeLeft.date(from: self.item!.mapValue.fields.endDayAndTime.stringValue)!)).fontWeight(.light).font(.system(size: 15))
                }
            }
        }
    }
}

struct HomeView: View {
    //TODO: need to have a list containing all the objects: events, goals, routines
    // issue: can we display events in same list if in different models?
    
    // below has goals and routines
    @ObservedObject private var model = FirebaseServices.shared
    
    // below has events
    // @ObservedObject private var eventModel = FirebaseServ
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
                        //ForEach(self.model.data!.filter({$0.mapValue.fields.isDisplayedToday.booleanValue}), id: \.mapValue.fields.id.stringValue) { item in
                        ForEach(Array(self.model.data!.enumerated()), id: \.offset) { index, item in
                            NavigationLink(destination: TasksView(goalOrRoutine: item, goalOrRoutineIndex: index)) {
                                HStack {
                                    infoView(item: item)
//                                    Spacer()
//
//                                    //TODO: set isComplete and hasTasks to actual values
//                                    VStack(alignment: .center) {
//                                        Button(action: {
//                                            if(item.mapValue.fields.isComplete!.booleanValue){
//                                                print("Already complete!")
//                                            }
//                                            else{
//                                                self.model.data![index].mapValue.fields.isComplete?.booleanValue = true
//
//                                                self.model.startGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
//                                                                       routineId: item.mapValue.fields.id.stringValue,
//                                                                       taskId: "NA",
//                                                                       taskNumber: index,
//                                                                       stepNumber: -1,
//                                                                       start: "goal")
//
//                                                print("zz")
//                                            }
//                                        }){
//                                            if (item.mapValue.fields.isComplete?.booleanValue ?? false) {
//                                                Image(systemName: "checkmark.circle")
//                                                    .font(.subheadline)
//                                                    .imageScale(.large)
//                                                    .foregroundColor(.green)
//                                            }
//                                            else {
//                                                Image(systemName: "circle")
//                                                    .font(.subheadline)
//                                                    .imageScale(.large)
//                                            }
//                                        }.buttonStyle(PlainButtonStyle())
//
//                                        Spacer()
//                                        if (!(self.model.goalsSubtasks[item.mapValue.fields.id.stringValue] == nil)) {
//                                            Image(systemName: "plus.circle")
//                                                .font(.subheadline)
//                                                .imageScale(.small)
//                                                .accentColor(.white)
//                                        }
//                                    }.padding(EdgeInsets(top: 8, leading: 0, bottom: 2, trailing: 0))
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
