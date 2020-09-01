//
//  TasksView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/3/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct TaskItem: View {
    @State var showSteps: Bool = false
    var task: ValueTask?
    var index: Int?
    var goalOrRoutineIndex: Int?
    var goalOrRoutineID: String?
    var fullDayArray: Bool
    @ObservedObject private var model = FirebaseGoogleService.shared
    
    @ObservedObject private var user = UserDay.shared
    
    @State var done = false
    
    var body: some View {
        VStack(alignment: .center) {
            Divider()
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(self.task!.mapValue.fields.title.stringValue)
                        .fontWeight(.bold)
                        .frame(width: 110)
                        .font(.system(size: 16, design: .rounded))
                        .lineLimit(2)
                    Text("Takes me " + self.task!.mapValue.fields.expectedCompletionTime!.stringValue)
                        .fontWeight(.light)
                        .frame(width: 110)
                        .font(.system(size: 12, design: .rounded))
                }
                if ( self.done || self.task!.mapValue.fields.isComplete!.booleanValue == true) {
                    AssetImage(urlName: self.task!.mapValue.fields.photo.stringValue, placeholder: Image("default-step"))
                        .aspectRatio(contentMode: .fit)
                        .opacity(0.60)
                        .overlay(Image(systemName: "checkmark.circle")
                            .font(.system(size:55))
                            .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                            .foregroundColor(.green))
                } else {
                    AssetImage(urlName: self.task!.mapValue.fields.photo.stringValue, placeholder: Image("default-step"))
                        .aspectRatio(contentMode: .fit)
                }
            }
            Spacer()
            if(!self.done && (self.task!.mapValue.fields.isComplete!.booleanValue == false)){
                Button(action: {
                    // complete task
                    self.model.completeActionOrTask(userId: self.user.User,
                                              routineId: self.goalOrRoutineID!,
                                              taskId: self.task!.mapValue.fields.id.stringValue,
                                              routineNumber: -1,
                                              taskNumber: self.index!,
                                              stepNumber: -1)
                    print("task complete")
                    // update task in model
                    self.model.goalsSubtasks[self.goalOrRoutineID!]!![self.index!].mapValue.fields.isComplete?.booleanValue = true
                    // decrement tasks left for goal
                    self.model.goalSubtasksLeft[self.goalOrRoutineID!]! -= 1
                    if self.model.goalsSubtasks[self.goalOrRoutineID!]!![self.index!].mapValue.fields.isMustDo!.booleanValue == true {
                        self.model.isMustDoTasks[self.goalOrRoutineID!]! -= 1
                    }
                    if self.model.goalSubtasksLeft[self.goalOrRoutineID!] == 0 || self.model.isMustDoTasks[self.goalOrRoutineID!] == 0{
                        print("goal complete")
                        // if no tasks left, update model
                        //self.model.data![self.goalOrRoutineIndex!].mapValue?.fields.isComplete!.booleanValue = true
                        if self.fullDayArray {
                            self.user.UserDayData[self.goalOrRoutineIndex!].mapValue!.fields.isComplete!.booleanValue = true
                        }
                        else {
                            self.user.UserDayBlockData[self.goalOrRoutineIndex!].mapValue!.fields.isComplete!.booleanValue = true
                        }
                        // set goal to complete
                        self.model.completeGoalOrRoutine(userId: self.user.User,
                                                  routineId: self.goalOrRoutineID!,
                                                  taskId: "NA",
                                                  routineNumber: self.goalOrRoutineIndex!,
                                                  taskNumber: -1,
                                                  stepNumber: -1)
                    } else {
                        print("goal not complete yet")
                        // goal is not complete so set to in progress, update model
                        //self.model.data![self.goalOrRoutineIndex!].mapValue?.fields.isInProgress!.booleanValue = true
                        if self.fullDayArray {
                            self.user.UserDayData[self.goalOrRoutineIndex!].mapValue!.fields.isInProgress!.booleanValue = true
                        }
                        else {
                            self.user.UserDayBlockData[self.goalOrRoutineIndex!].mapValue!.fields.isInProgress!.booleanValue = true
                        }
                        // start goal
                        self.model.startGoalOrRoutine(userId: self.user.User,
                                               routineId: self.goalOrRoutineID!,
                                               taskId: "NA",
                                               routineNumber: self.goalOrRoutineIndex!,
                                               taskNumber: -1,
                                               stepNumber: -1)
                    }
                    self.done = true
                    self.showSteps = false
                }) {
                    Text("Done?")
                        .fontWeight(.bold)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(.green)
                }.padding(2)
            } else {
                RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous)
                    .stroke(Color.green, lineWidth: 1)
                    .frame(width:140, height:25)
                    .overlay(Text("Task Completed")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .font(.system(size: 16, design: .rounded)))
                    .padding(2)
            }
        }
    }
}

struct TasksView: View {
    @ObservedObject private var model = FirebaseGoogleService.shared
    @ObservedObject private var user = UserDay.shared
    //    @Binding var showTasks: Bool
    var goalOrRoutine: Value?
    var goalOrRoutineIndex: Int?
    var fullDayArray: Bool
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
                                .font(.system(size:55))
                                .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                                .foregroundColor(.green))
                    } else {
                        AssetImage(urlName: self.goalOrRoutine!.mapValue!.fields.photo.stringValue, placeholder: Image("default-goal"))
                            .aspectRatio(contentMode: .fit)
                    }
                    Text(self.goalOrRoutine!.mapValue!.fields.title.stringValue)
                        .fontWeight(.bold)
                        .lineLimit(nil)
                        .padding()
                        .font(.system(size: 18, design: .rounded))
                    Text("Takes me " + self.goalOrRoutine!.mapValue!.fields.expectedCompletionTime.stringValue)
                        .fontWeight(.light)
                        .font(.system(size: 12, design: .rounded))
                    Spacer()
                    if(!self.done && (self.goalOrRoutine!.mapValue!.fields.isComplete!.booleanValue == false)){
                        Button(action: {
                            print("done button clicked")
                            self.model.completeGoalOrRoutine(userId: self.user.User,
                                                      routineId: self.goalOrRoutine!.mapValue!.fields.id.stringValue,
                                                      taskId: "NA",
                                                      routineNumber: self.goalOrRoutineIndex!,
                                                      taskNumber: -1,
                                                      stepNumber: -1)
                            if self.fullDayArray {
                                self.user.UserDayData[self.goalOrRoutineIndex!].mapValue!.fields.isComplete!.booleanValue = true
                            }
                            else {
                                self.user.UserDayBlockData[self.goalOrRoutineIndex!].mapValue!.fields.isComplete!.booleanValue = true
                            }
                            self.done = true
                        }) {
                            Text("Done?")
                                .fontWeight(.bold)
                                .font(.system(size: 16, design: .rounded))
                                .foregroundColor(.green)
                        }.padding(2)
                    } else {
                        RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous)
                        .stroke(Color.green, lineWidth: 1)
                        .frame(width:140, height:25)
                        .overlay(Text("Goal Completed")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .font(.system(size: 16, design: .rounded)))
                        .padding(2)
                    }
                }
            } else {
                ScrollView([.vertical]) {
                    VStack(alignment: .center) {
                       if (self.done || (self.goalOrRoutine!.mapValue!.fields.isComplete!.booleanValue == true)){
                            AssetImage(urlName: self.goalOrRoutine!.mapValue!.fields.photo.stringValue, placeholder: Image("default-task"))
                                .aspectRatio(contentMode: .fit)
                                .opacity(0.60)
                                .overlay(Image(systemName: "checkmark.circle")
                                    .font(.system(size:65))
                                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                                    .foregroundColor(.green))
                        } else {
                            AssetImage(urlName: self.goalOrRoutine!.mapValue!.fields.photo.stringValue, placeholder: Image("default-task"))
                                .aspectRatio(contentMode: .fit)
                        }
                        VStack {
                            Text(self.goalOrRoutine!.mapValue!.fields.title.stringValue)
                                .fontWeight(.bold)
                                .lineLimit(nil)
                                .font(.system(size: 18, design: .rounded))
                            Text("Takes me " + self.goalOrRoutine!.mapValue!.fields.expectedCompletionTime.stringValue)
                                .fontWeight(.light)
                                .font(.system(size: 12, design: .rounded))
                        }
                        Spacer()
                        if(!self.done && (self.goalOrRoutine!.mapValue!.fields.isComplete!.booleanValue == true)){
                            RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous)
                                .stroke(Color.green, lineWidth: 1)
                                .frame(width:140, height:25)
                                .overlay(Text("Task Completed")
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                    .font(.system(size: 16, design: .rounded)))
                                .padding(2)
                        }
                    }.padding(.bottom, 0)
                    ForEach(Array(self.model.goalsSubtasks[self.goalOrRoutine!.mapValue!.fields.id.stringValue]!!.enumerated()), id: \.offset) { index, item in
                        VStack(alignment: .leading) {
                            if item.mapValue.fields.isAvailable?.booleanValue ?? true {
                                TaskItem(task: item, index: index, goalOrRoutineIndex: self.goalOrRoutineIndex!, goalOrRoutineID: self.goalOrRoutine!.mapValue!.fields.id.stringValue, fullDayArray: self.fullDayArray)
                            }
                        }
                    }
                }.frame(height: geo.size.height)
                    .padding(0)
                    .navigationBarTitle("Steps")
            }
        }
    }
}

