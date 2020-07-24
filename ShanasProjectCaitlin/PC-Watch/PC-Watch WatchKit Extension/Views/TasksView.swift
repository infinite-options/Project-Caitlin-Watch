//
//  TasksView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/3/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct TaskItem: View {
//    @Binding var showTasks: Bool
    @State var showSteps: Bool = false
    var task: ValueTask?
    var index: Int?
    var goalOrRoutineIndex: Int?
    var goalOrRoutineID: String?
    @ObservedObject private var model = FirebaseGoogleService.shared
    
    @State var started = false
    
    var body: some View {
        HStack{
            NavigationLink(destination: StepsView(showSteps: $showSteps, goalID: goalOrRoutineID, goalOrRoutineIndex: goalOrRoutineIndex, task: task, taskIndex: index), isActive: $showSteps){
                VStack(alignment: .leading) {
                    HStack {
                        Text(self.task!.mapValue.fields.title.stringValue)
                            .fontWeight(.bold)
                            .font(.system(size: 20, design: .rounded))
                        Spacer()
                        if (!(self.model.taskSteps[task!.mapValue.fields.id.stringValue] == nil)) {
                            Image(systemName: "plus.circle")
                                .font(.subheadline)
                                .imageScale(.small)
                                .accentColor(.white)
                        } else {
                            if (!(task!.mapValue.fields.isComplete!.booleanValue) && !(task!.mapValue.fields.isInProgress!.booleanValue)) {
                                Text("Go")
                                    .overlay(Circle()
                                        .stroke(Color.green, lineWidth: 1)
                                        .frame(width:27, height:27)
                                        .padding(0)
                                        .foregroundColor(.green))
                                    .foregroundColor(.green)
                                    .onTapGesture {
                                        self.started = true
                                        print("Starting...")
                                        // starting task
                                        self.model.startGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                               routineId: self.goalOrRoutineID!,
                                                               taskId: self.task!.mapValue.fields.id.stringValue,
                                                               taskNumber: self.index!,
                                                               stepNumber: self.index!,
                                                               start: "task")
                                        // update task in model
                                        self.model.goalsSubtasks[self.goalOrRoutineID!]!![self.index!].mapValue.fields.isInProgress?.booleanValue = true
                                        // update goal in model
                                        self.model.data![self.goalOrRoutineIndex!].mapValue?.fields.isInProgress!.booleanValue = true
                                        //start goal
                                        self.model.startGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                               routineId: self.goalOrRoutineID!,
                                                               taskId: "NA",
                                                               taskNumber: self.goalOrRoutineIndex!,
                                                               stepNumber: -1,
                                                               start: "goal")
                                        print(self.model.goalsSubtasks[self.goalOrRoutineID!]!![self.index!].mapValue.fields.isInProgress!.booleanValue)
                                    }
                            } else if (self.started || task!.mapValue.fields.isInProgress!.booleanValue) {
                                Image(systemName: "arrow.2.circlepath.circle")
                                    .font(.subheadline)
                                    .imageScale(.large)
                                    .foregroundColor(.yellow)
                            } else if (task!.mapValue.fields.isComplete!.booleanValue) {
                                Image(systemName: "checkmark.circle")
                                    .font(.subheadline)
                                    .imageScale(.large)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    Spacer()
                    HStack {
                        if (self.task!.mapValue.fields.isComplete!.booleanValue == true){
                            SmallAssetImage(urlName: self.task!.mapValue.fields.photo.stringValue, placeholder: Image("default-task"))
                               .aspectRatio(contentMode: .fit)
                               .opacity(0.60)
                               .overlay(Image(systemName: "checkmark.circle")
                                   .font(.system(size:44))
                                   .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                                   .foregroundColor(.green))
                        } else {
                            SmallAssetImage(urlName: self.task!.mapValue.fields.photo.stringValue, placeholder: Image("default-task"))
                                .aspectRatio(contentMode: .fit)
                        }
                        Text("Takes " + self.task!.mapValue.fields.expectedCompletionTime!.stringValue)
                            .fontWeight(.light)
                            .font(.system(size: 15))
                    }
                }.padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
            }
        }.padding(EdgeInsets(top: 3, leading: 2, bottom: 4, trailing: 0))
    }
}

struct TasksView: View {
   @ObservedObject private var model = FirebaseGoogleService.shared
//    @Binding var showTasks: Bool
    var goalOrRoutine: Value?
    var goalOrRoutineIndex: Int?
    @State var done = false
    
    var body: some View {
        GeometryReader { geo in
            if (self.model.goalsSubtasks[self.goalOrRoutine!.mapValue!.fields.id.stringValue] == nil) {
                VStack(alignment: .center) {
                    if (self.done || (self.goalOrRoutine!.mapValue!.fields.isComplete!.booleanValue == true)){
                        AssetImage(urlName: self.goalOrRoutine!.mapValue!.fields.photo.stringValue, placeholder: Image("default-goal"))
                            .aspectRatio(contentMode: .fit)
                            .opacity(0.60)
                            .overlay(Image(systemName: "checkmark.circle")
                                .font(.system(size:65))
                                .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                                .foregroundColor(.green))
                    } else {
                        AssetImage(urlName: self.goalOrRoutine!.mapValue!.fields.photo.stringValue, placeholder: Image("default-goal"))
                            .aspectRatio(contentMode: .fit)
                    }
                    Text(self.goalOrRoutine!.mapValue!.fields.title.stringValue).lineLimit(nil).padding().font(.system(size: 20))
                    Spacer()
                    if(!self.done && (self.goalOrRoutine!.mapValue!.fields.isComplete!.booleanValue == false)){
                        Button(action: {
                            print("done button clicked")
                            self.model.completeGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                      routineId: self.goalOrRoutine!.mapValue!.fields.id.stringValue,
                                                      taskId: "NA",
                                                      routineNumber: self.goalOrRoutineIndex!,
                                                      taskNumber: -1,
                                                      stepNumber: -1,
                                                      start: "goal")
                            self.model.data![self.goalOrRoutineIndex!].mapValue!.fields.isComplete!.booleanValue = true
                            self.done = true
                        }) {
                            Text("Done?")
                                .foregroundColor(.green)
                        }
                    } else {
                        Text("Task Completed")
                            .overlay(RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous)
                                .stroke(Color.green, lineWidth: 1)
                                .frame(width:140, height:25))
                            .foregroundColor(.green)
                    }
                }
            }
            else{
                VStack {
                    Text(self.goalOrRoutine!.mapValue!.fields.title.stringValue)
                        .font(.system(size: 20, design: .rounded))
                    HStack {
                        Text("Duration: " + self.goalOrRoutine!.mapValue!.fields.expectedCompletionTime.stringValue)
                            .fontWeight(.light)
                            .font(.system(size: 15))
//                        Text(formatter.string(from: timeLeft.date(from: self.goalOrRoutine!.mapValue.fields.startDayAndTime.stringValue)!)  + " - " + formatter.string(from: timeLeft.date(from: self.goalOrRoutine!.mapValue.fields.endDayAndTime.stringValue)!)).fontWeight(.light).font(.system(size: 15))
                    }
                    List {
                        ForEach(Array(self.model.goalsSubtasks[self.goalOrRoutine!.mapValue!.fields.id.stringValue]!!.enumerated()), id: \.offset) { index, item in
                            VStack(alignment: .leading) {
                                if item.mapValue.fields.isAvailable?.booleanValue ?? true {
                                    TaskItem(task: item, index: index, goalOrRoutineIndex: self.goalOrRoutineIndex!, goalOrRoutineID: self.goalOrRoutine!.mapValue!.fields.id.stringValue)
                                }
                            }
                        }
                    }.navigationBarTitle("Tasks")
                }
            }
        }
    }
}

//struct TasksView_Previews: PreviewProvider {
//    static var previews: some View {
//        TasksView()
//    }
//}
