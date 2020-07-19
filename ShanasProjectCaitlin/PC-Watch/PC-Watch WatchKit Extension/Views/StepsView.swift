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
    var goalOrRoutineID: String?
    @State var done = false
    
    var body: some View {
        VStack {
            Divider()
            VStack {
                HStack {
                    if (self.done || (self.step!.mapValue.fields.isComplete!.booleanValue == true)) {
                        AsyncImage(url: URL(string:self.step!.mapValue.fields.photo.stringValue)!, placeholder: Image(""))
                            .aspectRatio(contentMode: .fit)
                            .opacity(0.60)
                            .overlay(Image(systemName: "checkmark.circle")
                                .font(.system(size:65))
                                .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                                .foregroundColor(.green))
                    } else {
                        AsyncImage(url: URL(string:self.step!.mapValue.fields.photo.stringValue)!, placeholder: Image(""))
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
                        self.model.completeGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                  routineId: self.goalOrRoutineID!,
                                                  taskId: self.taskID!,
                                                  routineNumber: -1,
                                                  taskNumber: -1,
                                                  stepNumber: self.index!,
                                                  start: "step")
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

func buttonAction() -> Void{
    print("Starting")
    return
}

struct StepsView: View {
    @ObservedObject private var model = FirebaseServices.shared
    var goalID: String?
    var task: ValueTask?
    var taskIndex: Int?
    @State var done = false
    
    var body: some View {
        GeometryReader { geo in
            
            VStack(alignment: .center) {
                if (self.model.taskSteps[self.task!.mapValue.fields.id.stringValue] == nil) {
                    if (self.done || (self.task!.mapValue.fields.isComplete!.booleanValue == true)){
                        AsyncImage(url: URL(string:self.task!.mapValue.fields.photo.stringValue)!, placeholder: Image(""))
                            .aspectRatio(contentMode: .fit)
                            .opacity(0.60)
                            .overlay(Image(systemName: "checkmark.circle")
                                .font(.system(size:65))
                                .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                                .foregroundColor(.green))
                    } else {
                        AsyncImage(url: URL(string:self.task!.mapValue.fields.photo.stringValue)!, placeholder: Image(""))
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
                            self.model.completeGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                      routineId: self.goalID!,
                                                      taskId: self.task!.mapValue.fields.id.stringValue,
                                                      routineNumber: -1,
                                                      taskNumber: self.taskIndex!,
                                                      stepNumber: -1,
                                                      start: "task")
                            print("completed")
                            self.done = true
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
                            AsyncImage(url: URL(string:self.task!.mapValue.fields.photo.stringValue)!, placeholder: Image(""))
                                .aspectRatio(contentMode: .fit)
                            Text(self.task!.mapValue.fields.title.stringValue)
                                .font(.system(size: 20, design: .rounded))
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(EdgeInsets(top: 8, leading: 2, bottom: 0, trailing: 2))
                            Text("Takes " + self.task!.mapValue.fields.expectedCompletionTime!.stringValue)
                                .fontWeight(.light)
                                .font(.system(size: 15))
                        }.padding(.bottom, 0)
                        ForEach(Array(self.model.taskSteps[self.task!.mapValue.fields.id.stringValue]!!.enumerated()), id: \.offset) { index, item in
                            VStack(alignment: .leading) {
                                if item.mapValue.fields.isAvailable?.booleanValue ?? true {
                                    StepView(step: item, index: index, taskID: self.task!.mapValue.fields.id.stringValue, goalOrRoutineID: self.goalID!)
                                }
                            }
                        }
                    }.frame(height: geo.size.height)
                        .padding(0)
                }
            }.navigationBarTitle("Steps")
        }
    }
}

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView()
    }
}
