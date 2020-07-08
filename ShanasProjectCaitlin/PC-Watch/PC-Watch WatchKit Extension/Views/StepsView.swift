//
//  StepsView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/3/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct StepsView: View {
     @ObservedObject private var model = FirebaseServices.shared
       var taskID: String?
       var itemID: String?
       
       var body: some View {
           GeometryReader { geo in
               VStack {
                   VStack {
                       Text("\(DayDateObj.day[DayDateObj.weekday]), \(DayDateObj.dueDate, formatter: DayDateObj.taskDateFormat)")
                           .font(.system(size: 15.0, design: .rounded))
                   }.frame(maxWidth: geo.size.width, alignment: .leading)
               
                   Text("Instructions.").foregroundColor(Color.red)
                       .font(.system(.headline, design: .rounded))
                   Spacer()
                   if (self.self.model.taskSteps[self.taskID!] == nil) {
                       Text("No instructions and steps found!")
                       Spacer()
                   }
                   else {
                       List {
                           ForEach(self.model.taskSteps[self.taskID!]!!, id: \.mapValue.fields.title.stringValue) { item in
                               VStack(alignment: .leading) {
                                   if item.mapValue.fields.isAvailable.booleanValue {
                                       if item.mapValue.fields.photo.stringValue != "" {
                                           HStack {
                                               AsyncImage(
                                                   url:URL(string: item.mapValue.fields.photo.stringValue)!,
                                                       placeholder: Image("blacksquare"))
                                                       .aspectRatio(contentMode: .fit)
                                               Text(item.mapValue.fields.title.stringValue)
                                           }
                                       }
                                   }
                               }.onTapGesture {
                                   print("Step ID: ")
                                   print(item.mapValue.fields.id.stringValue)
                               }
                           }
                       }
                   }
               }
           }
       }
}

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView()
    }
}
