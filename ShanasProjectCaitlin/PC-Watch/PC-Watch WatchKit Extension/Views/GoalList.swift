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
    //@ObservedObject var model: StepsModel
    @State var data = [ValueTask]()
    @State var goalID: String
    //@ObservedObject var col = model.rowColor
    //@ObservedObject var InstructModel: InstructionsStep
    
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
    @State var data = [ValueTask]()
    @State var taskID: String
    @State var goalID: String
    
    var body: some View {
        List {
            ForEach(self.data, id: \.mapValue.fields.id.stringValue) { item in
                VStack(alignment: .leading) {
                    if item.mapValue.fields.isAvailable.booleanValue {
                        if item.mapValue.fields.photo.stringValue != "" {
                                HStack {
                                    AsyncImage(
                                        url: URL(string: item.mapValue.fields.photo.stringValue)!,
                                            placeholder: Image("blacksquare")
                                                ).aspectRatio(contentMode: .fit)
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


struct GoalList: View {
    @State var data = [Value]()
    @ObservedObject var model: StepsModel
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    Text("\(DayDateObj.day[DayDateObj.weekday]), \(DayDateObj.dueDate, formatter: DayDateObj.taskDateFormat)")
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
                                        }
                                    }
                                }
                            }
                        }
                    }
                }.onAppear {
                    FirebaseServices().getFirebaseData() {
                        (data) in self.data = data
                    }
                }
                PersistentView(goal: false, event: true, routine: true, help: true)
            }.edgesIgnoringSafeArea(.bottom).padding(0)
        }
    }
}

struct GoalList_Previews: PreviewProvider {
    static var previews: some View {
        GoalList(model: StepsModel())
    }
}
