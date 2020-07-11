//
//  TasksView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/3/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct TaskItem: View {
    var taskID: String?
    var itemID: String?
    var taskName: String?
    var photo: String?
    @State var started = false
    
    var body: some View {
        HStack{
            NavigationLink(destination: StepsView(taskID: taskID!, itemID: itemID!, taskName: taskName!, photo: photo!)){
                HStack {
                    AsyncSmallImage(url: URL(string:self.photo!)!, placeholder: Image("blacksquare")).aspectRatio(contentMode: .fit)
                    Text(" " + taskName!)
                }
            }
            Spacer()
            Divider()
            if (!self.started) {
                Text("Go")
                    .foregroundColor(.green)
                    .onTapGesture {
                        self.started = true
                        print("Starting...")
                    }
            } else {
                Text("Started")
                .foregroundColor(.yellow)
            }
        }
    }
}

struct TasksView: View {
   @ObservedObject private var model = FirebaseServices.shared
    var itemID: String?
    var time: String?
    var name: String?
    
    var body: some View {
        GeometryReader { geo in
//            VStack {
//                Text("Plant flowers")
//                HStack {
//                    Text("10:00 - 11:00")
//                    Spacer()
//                    Text("30 min")
//                }
//                List {
//                    TaskItem(taskID: "task1ID", itemID: "Plant flowers", taskName: "Task 1")
//                    TaskItem(taskID: "task2ID", itemID: "Plant flowers", taskName: "Task 2")
//                    TaskItem(taskID: "task3ID", itemID: "Plant flowers", taskName: "Task 3")
//                    TaskItem(taskID: "task4ID", itemID: "Plant flowers", taskName: "Task 4")
//                    TaskItem(taskID: "task5ID", itemID: "Plant flowers", taskName: "Task 5")
//                }.navigationBarTitle("Tasks")
//            }.padding(0)
            if (self.model.goalsSubtasks[self.itemID!] == nil) {
                VStack {
                    Text("No actions and tasks found!")
                    Spacer()
                }
            }
            else{
                VStack {
                    Text(self.name!)
                    HStack {
                        Text(self.time!)
                    }
                    List {
                        ForEach(self.model.goalsSubtasks[self.itemID!]!!, id: \.mapValue.fields.id.stringValue) { item in
                            VStack(alignment: .leading) {
                                if item.mapValue.fields.isAvailable.booleanValue {
                                    TaskItem(taskID: item.mapValue.fields.id.stringValue, itemID: self.itemID!, taskName: item.mapValue.fields.title.stringValue, photo: item.mapValue.fields.photo.stringValue)
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
