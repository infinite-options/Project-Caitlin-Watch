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
    @ObservedObject private var model = FirebaseServices.shared
    var goalID: String
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Tasks and Actions").foregroundColor(Color.red)
                                   .font(.system(.headline, design: .rounded))
                Spacer()
                if (self.model.goalsSubtasks[self.goalID] == nil) {
                    Text("No actions and tasks found!")
                    Spacer()
                }
                else{
                    List {
                        ForEach(self.model.goalsSubtasks[self.goalID]!!, id: \.mapValue.fields.id.stringValue) { item in
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
                                        }.frame(height: 60)
                                    }
                                }
                            }
                        }
                    }
                }
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct StepsView: View {
    @ObservedObject private var model = FirebaseServices.shared
    var taskID: String
    var goalID: String
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Instructions.").foregroundColor(Color.red)
                Spacer()
                if (self.self.model.taskSteps[self.taskID] == nil) {
                    Text("No instructions and steps found!")
                    Spacer()
                }
                else {
                    List {
                        ForEach(self.model.taskSteps[self.taskID]!!, id: \.mapValue.fields.title.stringValue) { item in
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
                    }
                }
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
    @ObservedObject private var model = FirebaseServices.shared
    var notificationHandler = NotificationHandler()
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Current Goals").foregroundColor(Color.red)
                    .font(.system(.headline, design: .rounded))
                Spacer()
                
                if (self.model.data == nil){
                    Text("You dont have any Goals to show!")
                    Spacer()
                }
                else{
                    List {
                        ForEach(self.model.data!.filter{!($0.mapValue.fields.isPersistent.booleanValue)}, id: \.mapValue.fields.id.stringValue) { item in
                            VStack(alignment: .leading) {
                                if item.mapValue.fields.isAvailable.booleanValue {
                                    if item.mapValue.fields.photo.stringValue != "" {
                                        NavigationLink(destination: TasksView(goalID: item.mapValue.fields.id.stringValue)){
                                            ScrollView(.horizontal){
                                            HStack {
                                                AsyncImage(
                                                    url: URL(string: item.mapValue.fields.photo.stringValue)!,
                                                        placeholder: Image("blacksquare")
                                                            ).aspectRatio(contentMode: .fit)
                                                        Text(item.mapValue.fields.title.stringValue)
                                                //Text(String(self.DayDateObj.getTimeLeft(givenDate: item.mapValue.fields.startDayAndTime.stringValue)))
                                            }
                                        }.frame(height: 100)
                                    }
                                }
                            }
                        }
                    }
                    }.listStyle(CarouselListStyle())
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
