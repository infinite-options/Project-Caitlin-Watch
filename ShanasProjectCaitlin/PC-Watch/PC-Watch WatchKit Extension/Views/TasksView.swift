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
    
    //TODO: set complete and has steps
    var complete = false
    var hasSteps = true
    @State var started = false
    
    var body: some View {
        HStack{
            NavigationLink(destination: StepsView(taskID: self.task!.mapValue.fields.id.stringValue, taskName: self.task!.mapValue.fields.title.stringValue, photo: self.task!.mapValue.fields.photo.stringValue)){
                VStack(alignment: .leading) {
                    AsyncSmallImage(url: URL(string:self.task!.mapValue.fields.photo.stringValue)!, placeholder: Image("blacksquare")).aspectRatio(contentMode: .fit)
                    Text(self.task!.mapValue.fields.title.stringValue)
                }
            }
            Spacer()
            VStack {
                if (!self.started) {
                    Text("Go")
                        .overlay(Circle().stroke(Color.green, lineWidth: 1)
                            .frame(width:27, height:27)
                            .padding(0)
                            .foregroundColor(.green))
                        .foregroundColor(.green)
                        .onTapGesture {
                            self.started = true
                            print("Starting...")
                        }
                } else if(self.started && self.complete) {
                    Image(systemName: "checkmark.circle")
                        .font(.subheadline)
                        .imageScale(.large)
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "arrow.2.circlepath.circle")
                        .font(.subheadline)
                        .imageScale(.large)
                        .foregroundColor(.yellow)
                }
                Spacer()
                if (hasSteps) {
                    Image(systemName: "plus.circle")
                        .font(.subheadline)
                        .imageScale(.small)
                        .accentColor(.white)
                }
            }.padding(EdgeInsets(top: 16, leading: 0, bottom: 4, trailing: 8))
            }.frame(height: 80).padding(EdgeInsets(top: 3, leading: 2, bottom: 8, trailing: 0))
    }
}

struct TasksView: View {
   @ObservedObject private var model = FirebaseServices.shared
    var goalOrRoutine: Value?
    
    var body: some View {
        GeometryReader { geo in
            if (self.model.goalsSubtasks[self.goalOrRoutine!.mapValue.fields.id.stringValue] == nil) {
                VStack {
                    Text(self.goalOrRoutine!.mapValue.fields.id.stringValue)
                    Text("No actions and tasks found!")
                    Spacer()
                }
            }
            else{
                VStack {
                    Text(self.goalOrRoutine!.mapValue.fields.title.stringValue).font(.system(size: 20, design: .rounded))
                    HStack {
                        Text(formatter.string(from: timeLeft.date(from: self.goalOrRoutine!.mapValue.fields.startDayAndTime.stringValue)!)  + " - " + formatter.string(from: timeLeft.date(from: self.goalOrRoutine!.mapValue.fields.endDayAndTime.stringValue)!)).fontWeight(.light).font(.system(size: 15))
                    }
                    List {
                        ForEach(self.model.goalsSubtasks[self.goalOrRoutine!.mapValue.fields.id.stringValue]!!, id: \.mapValue.fields.id.stringValue) { item in
                            VStack(alignment: .leading) {
                                if item.mapValue.fields.isAvailable?.booleanValue ?? true {
                                    TaskItem(task: item)
                                }
                            }
                        }
                    }.navigationBarTitle("Tasks")
                }.edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
