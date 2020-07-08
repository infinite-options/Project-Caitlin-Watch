//
//  StepsView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/3/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct StepView: View {
    var name = "Step"
    @State var done = false
    
    var body: some View {
        VStack {
            HStack {
                Text(name)
                Spacer()
                Divider()
                if(!self.done){
                    Text("Done?").foregroundColor(.green).onTapGesture {
                        print("completed")
                        self.done = true
                    }
                } else {
                    Text("Done")
                }
            }
            Divider()
        }
    }
}

struct StepsView: View {
     @ObservedObject private var model = FirebaseServices.shared
       var taskID: String?
       var itemID: String?
       
       var body: some View {
           GeometryReader { geo in
               VStack {
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
                                       HStack {
                                           Text(item.mapValue.fields.title.stringValue)
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
        StepView()
    }
}
