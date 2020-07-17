//
//  TasksView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/3/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct TaskItem: View {
    var task: ValueTask?
    var index: Int?
    var goalOrRoutineID: String?
    @ObservedObject private var model = FirebaseServices.shared
    
    //TODO: change to isInProgress
    @State var started = false
    
    var body: some View {
        HStack{
            NavigationLink(destination: StepsView(taskID: self.task!.mapValue.fields.id.stringValue, taskName: self.task!.mapValue.fields.title.stringValue, photo: self.task!.mapValue.fields.photo.stringValue, time: self.task!.mapValue.fields.expectedCompletionTime!.stringValue)){
                VStack(alignment: .leading) {
                    HStack {
                        Text(self.task!.mapValue.fields.title.stringValue).fontWeight(.bold).font(.system(size: 20))
                        Spacer()
                        if (!(self.model.taskSteps[task!.mapValue.fields.id.stringValue] == nil)) {
                            
                            Image(systemName: "plus.circle")
                                .font(.subheadline)
                                .imageScale(.small)
                                .accentColor(.white)
                        } else {
                            if ((self.started == true) && task!.mapValue.fields.isInProgress!.booleanValue) {
                                Image(systemName: "arrow.2.circlepath.circle")
                                    .font(.subheadline)
                                    .imageScale(.large)
                                    .foregroundColor(.yellow)
                            } else if ((self.started == true) && task!.mapValue.fields.isComplete!.booleanValue) {
                                Image(systemName: "checkmark.circle")
                                    .font(.subheadline)
                                    .imageScale(.large)
                                    .foregroundColor(.green)
                                
                            } else {
                                Text("Go")
                                    .overlay(Circle().stroke(Color.green, lineWidth: 1)
                                        .frame(width:27, height:27)
                                        .padding(0)
                                        .foregroundColor(.green))
                                    .foregroundColor(.green)
                                    .onTapGesture {
                                        self.started = true
                                        print("Starting...")
                                        self.model.startGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                                               routineId: self.goalOrRoutineID!,
                                                               taskId: self.task!.mapValue.fields.id.stringValue,
                                                               taskNumber: self.index!,
                                                               stepNumber: self.index!,
                                                               start: "task")
                                    }
                            }
                        }
                    }
                    Spacer()
                    HStack {
                        AsyncSmallImage(url: URL(string:self.task!.mapValue.fields.photo.stringValue)!, placeholder: Image("blacksquare")).aspectRatio(contentMode: .fit)
                        Text("Takes " + self.task!.mapValue.fields.expectedCompletionTime!.stringValue).fontWeight(.light).font(.system(size: 15))
                    }
                }.padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
            }
        }.padding(EdgeInsets(top: 3, leading: 2, bottom: 4, trailing: 0))
    }
}

struct TasksView: View {
   @ObservedObject private var model = FirebaseServices.shared
    var goalOrRoutine: Value?
    var goalOrRoutineIndex: Int?
    @State var done = false
    
    var body: some View {
        GeometryReader { geo in
            if (self.model.goalsSubtasks[self.goalOrRoutine!.mapValue.fields.id.stringValue] == nil) {
                VStack(alignment: .center) {
                    if (self.done){
                        AsyncImage(url: URL(string:self.goalOrRoutine!.mapValue.fields.photo.stringValue)!, placeholder: Image("blacksquare")).aspectRatio(contentMode: .fit).opacity(0.60)
                            .overlay(Image(systemName: "checkmark.circle")
                                .font(.system(size:65))
                                .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                                .foregroundColor(.green))
                    } else {
                        AsyncImage(url: URL(string:self.goalOrRoutine!.mapValue.fields.photo.stringValue)!, placeholder: Image("blacksquare")).aspectRatio(contentMode: .fit)
                    }
                    Text(self.goalOrRoutine!.mapValue.fields.title.stringValue).lineLimit(nil).padding().font(.system(size: 20))
                    Spacer()
                    if(!self.done){
                        Button(action: {
                            self.model.completeGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                routineId: self.goalOrRoutine!.mapValue.fields.id.stringValue,
                                taskId: "NA",
                                taskNumber: self.goalOrRoutineIndex!,
                                stepNumber: -1,
                                start: "goal")
                        }) {
                            Text("Done?").foregroundColor(.green).onTapGesture {
                                print("completed")
                                self.done = true
                            }
                        }
                    } else {
                        Text("Task Completed").overlay(RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous).stroke(Color.green, lineWidth: 1).frame(width:140, height:25))
                            .foregroundColor(.green)
                    }
                }
            }
            else{
                VStack {
                    Text(self.goalOrRoutine!.mapValue.fields.title.stringValue).font(.system(size: 20, design: .rounded))
                    HStack {
                        Text("Duration: " + self.goalOrRoutine!.mapValue.fields.expectedCompletionTime.stringValue).fontWeight(.light).font(.system(size: 15))
//                        Text(formatter.string(from: timeLeft.date(from: self.goalOrRoutine!.mapValue.fields.startDayAndTime.stringValue)!)  + " - " + formatter.string(from: timeLeft.date(from: self.goalOrRoutine!.mapValue.fields.endDayAndTime.stringValue)!)).fontWeight(.light).font(.system(size: 15))
                    }
                    List {
                        ForEach(Array(self.model.goalsSubtasks[self.goalOrRoutine!.mapValue.fields.id.stringValue]!!.enumerated()), id: \.offset) { index, item in
//                        ForEach(self.model.goalsSubtasks[self.goalOrRoutine!.mapValue.fields.id.stringValue]!!, id: \.mapValue.fields.id.stringValue) { item in
                            VStack(alignment: .leading) {
                                if item.mapValue.fields.isAvailable?.booleanValue ?? true {
                                    TaskItem(task: item, index: index, goalOrRoutineID: self.goalOrRoutine!.mapValue.fields.id.stringValue)
                                }
                            }
                        }
                    }.navigationBarTitle("Tasks")
                }
            }
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
