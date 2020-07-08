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
    
    var body: some View {
        HStack{
            NavigationLink(destination: StepsView(taskID: taskID!, itemID: itemID!)){
                Text(taskName!)
            }
            Divider()
            Text("Start")
                .foregroundColor(.green)
                .onTapGesture {
                    print("Starting...")
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
                        Spacer()
                        Text("Duration")
                    }
                    List {
                        ForEach(self.model.goalsSubtasks[self.itemID!]!!, id: \.mapValue.fields.id.stringValue) { item in
                            VStack(alignment: .leading) {
                                if item.mapValue.fields.isAvailable.booleanValue {
                                    TaskItem(taskID: item.mapValue.fields.id.stringValue, itemID: self.itemID!, taskName: item.mapValue.fields.title.stringValue)
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
