//
//  GoalList.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/8/20.
//  Updated by Shana Duchin 
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct TasksView: View {
    @State private var data = [ValueTask]()
    var goalID: String
    
    var body: some View{
        List {
            ForEach(self.data, id: \.mapValue.fields.id.stringValue) { item in
                VStack(alignment: .leading) {
                    if item.mapValue.fields.isAvailable.booleanValue {
                        if item.mapValue.fields.photo.stringValue != "" {
                            NavigationLink(destination: StepsView(taskID: item.mapValue.fields.id.stringValue, goalID: self.goalID)){
                                HStack {
                                    AsyncImage(
                                        url: URL(string: item.mapValue.fields.photo.stringValue)!,
                                            placeholder: Image("blacksquare")
                                                ).aspectRatio(contentMode: .fit)
                                            Text(item.mapValue.fields.title.stringValue)
                                }
                            }
                        }
                    }
                }
            }
        }.onAppear {
            FirebaseServices().getFirebaseTasks(goalID: self.goalID) {
                (data) in self.data = data
            }
        }
    }
}

struct StepsView: View {
    @State private var data = [ValueTask]()
    var taskID: String
    var goalID: String
    
    var body: some View {
        List {
            ForEach(self.data, id: \.mapValue.fields.id.stringValue) { item in
                VStack(alignment: .leading) {
                    if item.mapValue.fields.isAvailable.booleanValue {
                        if item.mapValue.fields.photo.stringValue != "" {
                            HStack {
                                AsyncImage(
                                    url:URL(string: item.mapValue.fields.photo.stringValue)!,
                                        placeholder: Image("blacksquare"))
                                        .aspectRatio(contentMode: .fit)
                                Text(item.mapValue.fields.title.stringValue)
                            }
                        }
                    }
                }.onTapGesture {
                    print("Step ID: ")
                    print(item.mapValue.fields.id.stringValue)
                }
            }
        }.onAppear {
            FirebaseServices().getFirebaseStep(stepID: self.taskID, goalID: self.goalID) {
                (data) in self.data = data
            }
        }
    }
}

/*
struct InstructionView: View{
    @ObservedObject var model: StepsModel
    //@ObservedObject var InstructModel: InstructionsStep
    var step: String
    
    var body: some View{
        VStack{
            HStack{
                Button(action: {
                    self.model.instructions[0].done = true
                    self.model.completed += 1
                    print("\(self.model.rowColor)")
                }){
                    if self.model.instructions[0].done == false {
                        self.model.instructions[0].img.renderingMode(.original)
                    }
                    else if self.model.instructions[0].done {
                        self.model.instructions[0].img.renderingMode(.original)
                        .overlay(Image("check")).opacity(0.4)
                    }
                }.buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    self.model.instructions[1].done = true
                    self.model.completed += 1
                }){
                    if self.model.instructions[1].done == false {
                        self.model.instructions[1].img.renderingMode(.original)
                    }
                    else if self.model.instructions[1].done {
                        self.model.instructions[1].img.renderingMode(.original)
                        .overlay(Image("check")).opacity(0.4)
                    }
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
}
*/

struct GoalList: View {
    @State private var data = [Value]()
    var DayDateObj = DayDate()
    var notific = NotificationHandler()
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    Text("\(self.DayDateObj.day[self.DayDateObj.weekday]), \(self.DayDateObj.dueDate, formatter: self.DayDateObj.taskDateFormat)")
                        .font(.system(size: 15.0, design: .rounded))
                }.frame(maxWidth: geo.size.width, alignment: .leading)
                    
                Text("Current Goals").foregroundColor(Color.red)
                    .font(.system(.headline, design: .rounded))
                Spacer()
                List {
                    ForEach(self.data.filter{!($0.mapValue.fields.isPersistent.booleanValue)}, id: \.mapValue.fields.id.stringValue) { item in
                        VStack(alignment: .leading) {
                            if item.mapValue.fields.isAvailable.booleanValue {
                                if item.mapValue.fields.photo.stringValue != "" {
                                    NavigationLink(destination: TasksView(goalID: item.mapValue.fields.id.stringValue)){
                                        HStack {
                                            AsyncImage(
                                                url: URL(string: item.mapValue.fields.photo.stringValue)!,
                                                    placeholder: Image("blacksquare")
                                                        ).aspectRatio(contentMode: .fit)
                                                    Text(item.mapValue.fields.title.stringValue)
                                            Text(String(self.DayDateObj.getTimeLeft(givenDate: item.mapValue.fields.startDayAndTime.stringValue)))
                                        }
                                    }.frame(height: 60)
                                }
                            }
                        }
                        .onAppear {
                            //User - Before
                            if (item.mapValue.fields.userNotifications.mapValue.fields.before.mapValue.fields.isEnabled.booleanValue){
                                self.notific.setBeforeNotification(
                                    message: item.mapValue.fields.userNotifications.mapValue.fields.before.mapValue.fields.message.stringValue,
                                    time:  item.mapValue.fields.userNotifications.mapValue.fields.before.mapValue.fields.time.stringValue,
                                    title: item.mapValue.fields.title.stringValue,
                                    startTime: item.mapValue.fields.startDayAndTime.stringValue)
                            }
                            //User - After
                            if (item.mapValue.fields.userNotifications.mapValue.fields.after.mapValue.fields.isEnabled.booleanValue){
                                self.notific.setAfterNotification(
                                    message: item.mapValue.fields.userNotifications.mapValue.fields.after.mapValue.fields.message.stringValue,
                                    time:  item.mapValue.fields.userNotifications.mapValue.fields.after.mapValue.fields.time.stringValue,
                                    title: item.mapValue.fields.title.stringValue,
                                    endTime: item.mapValue.fields.endDayAndTime.stringValue)
                            }
                            //User - During
                            if (item.mapValue.fields.userNotifications.mapValue.fields.during.mapValue.fields.isEnabled.booleanValue){
                                self.notific.setDuringNotification(
                                    message: item.mapValue.fields.userNotifications.mapValue.fields.during.mapValue.fields.message.stringValue,
                                    time:  item.mapValue.fields.userNotifications.mapValue.fields.during.mapValue.fields.time.stringValue,
                                    title: item.mapValue.fields.title.stringValue,
                                    startTime: item.mapValue.fields.startDayAndTime.stringValue)
                            }
                        }
                    }
                }.onAppear {
                    FirebaseServices().getFirebaseData	() {
                        (data) in self.data = data
                    }
                }.listStyle(CarouselListStyle())
                
                PersistentView(goal: false, event: true, routine: true, help: true)
            }.edgesIgnoringSafeArea(.bottom).padding(0)
        }
    }
}

struct GoalList_Previews: PreviewProvider {
    static var previews: some View {
        GoalList()
    }
}
