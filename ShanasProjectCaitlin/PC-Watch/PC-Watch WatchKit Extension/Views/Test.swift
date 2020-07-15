//
//  Test.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/14/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct Test: View {
    @ObservedObject private var model = FirebaseServices.shared
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).onTapGesture {
            self.model.startGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                   routineId: "azwuEBmbzPbUJNPmwFqI",
                                   taskId: "NA",
                                   taskNumber: 2,
                                   stepNumber: -1,
                                   start: "goal")
            
            self.model.startGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                    routineId: "azwuEBmbzPbUJNPmwFqI",
                                    taskId: "5umyA6otIqsydcAx1FLx",
                                    taskNumber: 6,
                                    stepNumber: -1,
                                    start: "task")
            
            self.model.startGRATIS(userId: "GdT7CRXUuDXmteS4rQwN",
                                    routineId: "azwuEBmbzPbUJNPmwFqI",
                                    taskId: "5umyA6otIqsydcAx1FLx",
                                    taskNumber: -1,
                                    stepNumber: 0,
                                    start: "step")
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
