//
//  StepsView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/3/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct StepView: View {
    @ObservedObject private var model = FirebaseServices.shared
    var step: ValueTask?
    var index: Int?
    var taskID: String?
    var taskIndex: Int?
    var goalOrRoutineID: String?
    var goalOrRoutineIndex: Int?
    @State var done = false
    
    var body: some View {
        VStack {
            Divider()
            VStack {
                HStack {
                    if (self.done || (self.step!.mapValue.fields.isComplete!.booleanValue == true)) {
                        AssetImage(urlName: self.step!.mapValue.fields.photo.stringValue, placeholder: Image("default-step"))
                            .aspectRatio(contentMode: .fit)
                            .opacity(0.60)
                            .overlay(Image(systemName: "checkmark.circle")
                                .font(.system(size:65))
                                .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                                .foregroundColor(.green))
                    } else {
                        AssetImage(urlName: self.step!.mapValue.fields.photo.stringValue, placeholder: Image("default-step"))
                            .aspectRatio(contentMode: .fit)
                    }
                    VStack(alignment: .leading) {
                        Text(self.step!.mapValue.fields.title.stringValue)
                            .frame(width: 110)
                            .font(.system(size: 15, design: .rounded))
                            .lineLimit(2)
                        Text("Takes: " + self.step!.mapValue.fields.expectedCompletionTime!.stringValue)
                            .frame(width: 110)
                            .font(.system(size: 10))
                    }
                }
                Spacer()
                if(!self.done && (self.step!.mapValue.fields.isComplete!.booleanValue == false)){
                    Button(action: {
                        //TODO: below not working
                        //Complete step
                        self.model.completeGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                  routineId: self.goalOrRoutineID!,
                                                  taskId: self.taskID!,
                                                  routineNumber: -1,
                                                  taskNumber: -1,
                                                  stepNumber: self.index!,
                                                  start: "step")
                        //update step in model
                        self.model.taskSteps[self.taskID!]!![self.index!].mapValue.fields.isComplete!.booleanValue = true
                        //TODO: Look a logic, task complete after only one step complete
                        //decrement number of steps left for task
                        self.model.taskStepsLeft[self.taskID!]! -= 1
                        if self.model.taskStepsLeft[self.taskID!]! == 0 {
                            //if task steps left == 0, task is complete so update data model
                            self.model.goalsSubtasks[self.goalOrRoutineID!]!![self.taskIndex!].mapValue.fields.isComplete!.booleanValue = true
                            //complete task
                            self.model.completeGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                      routineId: self.goalOrRoutineID!,
                                                      taskId: self.taskID!,
                                                      routineNumber: -1,
                                                      taskNumber: self.taskIndex!,
                                                      stepNumber: -1,
                                                      start: "task")
                            // decrement number of tasks left for goal
                            self.model.goalSubtasksLeft[self.goalOrRoutineID!]! -= 1
                            if self.model.goalSubtasksLeft[self.goalOrRoutineID!] == 0 {
                                //if goal has no tasks left, it is complete so update model
                                self.model.data![self.goalOrRoutineIndex!].mapValue.fields.isComplete!.booleanValue = true
                                // complete goal
                                self.model.completeGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                          routineId: self.goalOrRoutineID!,
                                                          taskId: self.taskID!,
                                                          routineNumber: self.goalOrRoutineIndex!,
                                                          taskNumber: -1,
                                                          stepNumber: -1,
                                                          start: "goal")
                            } else {
                                // goal is not complete so is inprogress
                                self.model.data![self.goalOrRoutineIndex!].mapValue.fields.isInProgress!.booleanValue = true
                                //start goal
                                self.model.startGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                       routineId: self.goalOrRoutineID!,
                                                       taskId: "NA",
                                                       taskNumber: self.goalOrRoutineIndex!,
                                                       stepNumber: -1,
                                                       start: "goal")
                            }
                        } else {
                            // task is not complete so set to in progress in model
                            self.model.goalsSubtasks[self.goalOrRoutineID!]!![self.taskIndex!].mapValue.fields.isInProgress!.booleanValue = true
                            // start task
                            self.model.startGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                   routineId: self.goalOrRoutineID!,
                                                   taskId: self.taskID!,
                                                   taskNumber: self.taskIndex!,
                                                   stepNumber: -1,
                                                   start: "task")
                            // set goal to in progress in model
                            self.model.data![self.goalOrRoutineIndex!].mapValue.fields.isInProgress!.booleanValue = true
                            // start goal
                            self.model.startGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                   routineId: self.goalOrRoutineID!,
                                                   taskId: "NA",
                                                   taskNumber: self.goalOrRoutineIndex!,
                                                   stepNumber: -1,
                                                   start: "goal")
                        }
                        print(self.model.taskSteps[self.taskID!]!![self.index!].mapValue.fields.isComplete!.booleanValue)
                        print("completed")
                        self.done = true
                    }) {
                        Text("Done?")
                            .foregroundColor(.green)
                    }
                } else {
                    Text("Completed")
                        .overlay(RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous)
                            .stroke(Color.green, lineWidth: 1)
                            .frame(width:120, height:25))
                        .foregroundColor(.green)
                        .foregroundColor(.green)
                }
            }
        }
    }
}

struct StepsView: View {
    @ObservedObject private var model = FirebaseServices.shared
//    @Binding var showTasks: Bool
    @Binding var showSteps: Bool
    var goalID: String?
    var goalOrRoutineIndex: Int?
    var task: ValueTask?
    var taskIndex: Int?
    @State var done = false
    
    var body: some View {
        GeometryReader { geo in
            
            VStack(alignment: .center) {
                if (self.model.taskSteps[self.task!.mapValue.fields.id.stringValue] == nil) {
                    if (self.done || (self.task!.mapValue.fields.isComplete!.booleanValue == true)){
                        AssetImage(urlName: self.task!.mapValue.fields.photo.stringValue, placeholder: Image("default-task"))
                            .aspectRatio(contentMode: .fit)
                            .opacity(0.60)
                            .overlay(Image(systemName: "checkmark.circle")
                                .font(.system(size:65))
                                .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                                .foregroundColor(.green))
                    } else {
                        AssetImage(urlName: self.task!.mapValue.fields.photo.stringValue, placeholder: Image("default-task"))
                            .aspectRatio(contentMode: .fit)
                    }
                    VStack {
                        Text(self.task!.mapValue.fields.title.stringValue)
                            .lineLimit(nil)
                            .font(.system(size: 20))
                        Text("Takes " + self.task!.mapValue.fields.expectedCompletionTime!.stringValue)
                            .fontWeight(.light)
                            .font(.system(size: 15))
                    }
                    Spacer()
                    if(!self.done && (self.task!.mapValue.fields.isComplete!.booleanValue == false)){
                        Button(action: {
                            // complete task
                            self.model.completeGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                      routineId: self.goalID!,
                                                      taskId: self.task!.mapValue.fields.id.stringValue,
                                                      routineNumber: -1,
                                                      taskNumber: self.taskIndex!,
                                                      stepNumber: -1,
                                                      start: "task")
                            // update task in model
                            self.model.goalsSubtasks[self.goalID!]!![self.taskIndex!].mapValue.fields.isComplete?.booleanValue = true
                            // decrement tasks left for goal
                            self.model.goalSubtasksLeft[self.goalID!]! -= 1
                            if self.model.goalSubtasksLeft[self.goalID!] == 0 {
                                // if no tasks left, update model
                                self.model.data![self.goalOrRoutineIndex!].mapValue.fields.isComplete!.booleanValue = true
                                // set goal to complete
                                self.model.completeGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                          routineId: self.goalID!,
                                                          taskId: "NA",
                                                          routineNumber: self.goalOrRoutineIndex!,
                                                          taskNumber: -1,
                                                          stepNumber: -1,
                                                          start: "goal")
                            } else {
                                // goal is not complete so set to in progress, update model
                                self.model.data![self.goalOrRoutineIndex!].mapValue.fields.isInProgress!.booleanValue = true
                                // start goal
                                self.model.startGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                       routineId: self.goalID!,
                                                       taskId: "NA",
                                                       taskNumber: self.goalOrRoutineIndex!,
                                                       stepNumber: -1,
                                                       start: "goal")
                            }
                            self.done = true
                            self.showSteps = false
                        }) {
                            Text("Done?").foregroundColor(.green)
                        }
                    } else {
                        Text("Task Completed")
                            .overlay(RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous)
                                .stroke(Color.green, lineWidth: 1)
                                .frame(width:140, height:25))
                            .foregroundColor(.green)
                    }
                }
                else {
                    ScrollView([.vertical]) {
                        VStack(alignment: .center) {
                            if (self.task!.mapValue.fields.isComplete!.booleanValue == true){
                                AssetImage(urlName: self.task!.mapValue.fields.photo.stringValue, placeholder: Image("default-task"))
                                    .aspectRatio(contentMode: .fit)
                                    .opacity(0.60)
                                    .overlay(Image(systemName: "checkmark.circle")
                                        .font(.system(size:65))
                                        .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                                        .foregroundColor(.green))
                            } else {
                                AssetImage(urlName:self.task!.mapValue.fields.photo.stringValue, placeholder: Image("default-task"))
                                    .aspectRatio(contentMode: .fit)
                            }
                            Text(self.task!.mapValue.fields.title.stringValue)
                                .font(.system(size: 20, design: .rounded))
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(EdgeInsets(top: 8, leading: 2, bottom: 0, trailing: 2))
                            Text("Takes " + self.task!.mapValue.fields.expectedCompletionTime!.stringValue)
                                .fontWeight(.light)
                                .font(.system(size: 15))
                            Spacer()
                            if(!self.done && (self.task!.mapValue.fields.isComplete!.booleanValue == false)){
                                Button(action: {
                                    // complete task
                                    self.model.completeGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                              routineId: self.goalID!,
                                                              taskId: self.task!.mapValue.fields.id.stringValue,
                                                              routineNumber: -1,
                                                              taskNumber: self.taskIndex!,
                                                              stepNumber: -1,
                                                              start: "task")
                                    // update task in model
                                    self.model.goalsSubtasks[self.goalID!]!![self.taskIndex!].mapValue.fields.isComplete?.booleanValue = true
                                    // decrement tasks left for goal
                                    self.model.goalSubtasksLeft[self.goalID!]! -= 1
                                    if self.model.goalSubtasksLeft[self.goalID!] == 0 {
                                        // if no tasks left, update model
                                        self.model.data![self.goalOrRoutineIndex!].mapValue.fields.isComplete!.booleanValue = true
                                        // set goal to complete
                                        self.model.completeGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                                  routineId: self.goalID!,
                                                                  taskId: "NA",
                                                                  routineNumber: self.goalOrRoutineIndex!,
                                                                  taskNumber: -1,
                                                                  stepNumber: -1,
                                                                  start: "goal")
                                    } else {
                                        // goal is not complete so set to in progress, update model
                                        self.model.data![self.goalOrRoutineIndex!].mapValue.fields.isInProgress!.booleanValue = true
                                        // start goal
                                        self.model.startGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                               routineId: self.goalID!,
                                                               taskId: "NA",
                                                               taskNumber: self.goalOrRoutineIndex!,
                                                               stepNumber: -1,
                                                               start: "goal")
                                    }
                                    self.done = true
                                    self.showSteps = false
                                }) {
                                    Text("Done?").foregroundColor(.green)
                                }
                            } else {
                                Text("Task Completed")
                                    .overlay(RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous)
                                        .stroke(Color.green, lineWidth: 1)
                                        .frame(width:140, height:25))
                                    .foregroundColor(.green)
                            }
                        }.padding(.bottom, 0)
                        ForEach(Array(self.model.taskSteps[self.task!.mapValue.fields.id.stringValue]!!.enumerated()), id: \.offset) { index, item in
                            VStack(alignment: .leading) {
                                if item.mapValue.fields.isAvailable?.booleanValue ?? true {
                                    StepView(step: item, index: index, taskID: self.task!.mapValue.fields.id.stringValue, taskIndex: self.taskIndex!, goalOrRoutineID: self.goalID!, goalOrRoutineIndex: self.goalOrRoutineIndex!)
                                }
                            }
                        }
//                        Divider()
//                        if(!self.done && (self.task!.mapValue.fields.isComplete!.booleanValue == false)){
//                            Button(action: {
//                                self.model.completeGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
//                                                          routineId: self.goalID!,
//                                                          taskId: self.task!.mapValue.fields.id.stringValue,
//                                                          routineNumber: -1,
//                                                          taskNumber: self.taskIndex!,
//                                                          stepNumber: -1,
//                                                          start: "task")
//                                self.model.goalsSubtasks[self.goalID!]!![self.taskIndex!].mapValue.fields.isComplete?.booleanValue = true
//                                print(self.model.goalsSubtasks[self.goalID!]!![self.taskIndex!].mapValue.fields.isComplete!.booleanValue)
//                                self.done = true
//                            }) {
//                                Text("Done?").foregroundColor(.green)
//                            }
//                        } else {
//                            Text("Task Completed")
//                                .overlay(RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous)
//                                    .stroke(Color.green, lineWidth: 1)
//                                    .frame(width:140, height:25))
//                                .foregroundColor(.green)
//                        }
//
                    }.frame(height: geo.size.height)
                        .padding(0)
                }
            }.navigationBarTitle("Steps")
        }
    }
}

//struct StepsView_Previews: PreviewProvider {
//    static var previews: some View {
//        StepsView()
//    }
//}
