//
//  GoalList.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/8/20.
//  Updated by Shana Duchin 
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct GoalImage: View {
    var body : some View {
        Image("Goals")
        .resizable()
        .frame(width: 30, height: 30)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 0.5))
        .shadow(radius: 10)
            .padding(EdgeInsets(top: 10, leading: 1, bottom: 10, trailing: 1.5))
    }
}

struct TasksView: View {
    
    @ObservedObject private var model = FirebaseServices.shared
    var goalID: String
    
    var body: some View {
        GeometryReader { geo in
            if (self.model.goalsSubtasks[self.goalID] == nil) {
                VStack {
                    Text("Tasks and Actions").foregroundColor(Color.red)
                    .font(.system(.headline, design: .rounded))
                    Text("No actions and tasks found!")
                    Spacer()
                }
            }
            else{
                List {
                    ForEach(self.model.goalsSubtasks[self.goalID]!!, id: \.mapValue.fields.id.stringValue) { item in
                        VStack(alignment: .leading) {
                            if item.mapValue.fields.isAvailable.booleanValue {
                                if item.mapValue.fields.photo.stringValue != "" {
                                    NavigationLink(destination: StepsView(taskID: item.mapValue.fields.id.stringValue, goalID: self.goalID)){
                                        HStack {
                                            GoalImage()
                                            Text(item.mapValue.fields.title.stringValue)
                                        }
                                    }.frame(height: 60)
                                }
                            }
                        }
                    }
                }.navigationBarTitle("Tasks and Actions")
            }
        }.edgesIgnoringSafeArea(.bottom)
    }
}

struct StepsView: View {
    @ObservedObject private var model = FirebaseServices.shared
    var taskID: String
    var goalID: String
    
    var body: some View {
        GeometryReader { geo in
            if (self.self.model.taskSteps[self.taskID] == nil) {
                VStack {
                    Text("Instructions").foregroundColor(Color.red)
                    .font(.system(.headline, design: .rounded))
                    Text("No instructions and steps found!")
                    Spacer()
                }
            }
            else {
                List {
                    ForEach(self.model.taskSteps[self.taskID]!!, id: \.mapValue.fields.title.stringValue) { item in
                        VStack(alignment: .leading) {
                            if item.mapValue.fields.isAvailable.booleanValue {
                                if item.mapValue.fields.photo.stringValue != "" {
                                    HStack {
                                        GoalImage()
                                        Text(item.mapValue.fields.title.stringValue)
                                    }
                                }
                            }
                        }.onTapGesture {
                            print("Step ID: ")
                            print(item.mapValue.fields.id.stringValue)
                        }.navigationBarTitle("Instructions")
                    }
                }
            }
        }
    }
}

struct GoalList: View {
    @ObservedObject private var model = FirebaseServices.shared
    var notificationHandler = NotificationHandler()
    
    let timeLeft: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        //formatter2.dateFormat = "dd MM yyyy'T'HH:mm:ss'Z'"
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
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                
                if (self.model.data == nil){
                    VStack {
                        Text("Current Goals").foregroundColor(Color.red)
                        .font(.system(.headline, design: .rounded))
                        Text("You dont have any Goals to show!")
                        Spacer()
                    }
                }
                else{
                    List {
                        ForEach(self.model.data!.filter{!($0.mapValue.fields.isPersistent.booleanValue)}, id: \.mapValue.fields.id.stringValue) { item in
                            VStack(alignment: .leading) {
                                if item.mapValue.fields.isAvailable.booleanValue {
                                    if item.mapValue.fields.photo.stringValue != "" {
                                        NavigationLink(destination: TasksView(goalID: item.mapValue.fields.id.stringValue)){
                                            ScrollView(.horizontal){
                                                VStack {
                                                    HStack {
                                                        GoalImage()
                                                        Spacer()
                                                        Text(item.mapValue.fields.title.stringValue)
                                                        //Text(String(self.DayDateObj.getTimeLeft(givenDate: item.mapValue.fields.startDayAndTime.stringValue)))
                                                    }
                                                    Text(self.formatter.string(from: self.timeLeft.date(from: item.mapValue.fields.startDayAndTime.stringValue)!)  + " - " + self.formatter.string(from: self.timeLeft.date(from: item.mapValue.fields.endDayAndTime.stringValue)!))
                                                }
                                            }.frame(height: 100)
                                        }
                                    }
                                }
                            }
                        }
                    }.listStyle(CarouselListStyle())
                        .navigationBarTitle("Current Goals")
                }
            }.edgesIgnoringSafeArea(.bottom).padding(0)
        }
    }
}

struct GoalList_Previews: PreviewProvider {
    static var previews: some View {
        GoalList()
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
