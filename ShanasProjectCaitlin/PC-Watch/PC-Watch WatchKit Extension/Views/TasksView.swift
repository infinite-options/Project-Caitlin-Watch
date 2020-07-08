//
//  TasksView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/3/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct TasksView: View {
   @ObservedObject private var model = FirebaseServices.shared
    var itemID: String?
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    Text("\(DayDateObj.day[DayDateObj.weekday]), \(DayDateObj.dueDate, formatter: DayDateObj.taskDateFormat)")
                        .font(.system(size: 15.0, design: .rounded))
                }.frame(maxWidth: geo.size.width, alignment: .leading)
                
                Text("Tasks").foregroundColor(Color.red)
                                   .font(.system(.headline, design: .rounded))
                Spacer()
                if (self.model.goalsSubtasks[self.itemID!] == nil) {
                    Text("No actions and tasks found!")
                    Spacer()
                }
                else{
                    List {
                        ForEach(self.model.goalsSubtasks[self.itemID!]!!, id: \.mapValue.fields.id.stringValue) { item in
                            VStack(alignment: .leading) {
                                if item.mapValue.fields.isAvailable.booleanValue {
                                    if item.mapValue.fields.photo.stringValue != "" {
                                        NavigationLink(destination: StepsView(taskID: item.mapValue.fields.id.stringValue, itemID: self.itemID!)){
                                            
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
                    }
                }
                PersistentView(goal: false, event: true, routine: true, help: true)
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
