//
//  StepsView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/3/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct StepView: View {
    var name: String
    @State var done = false
    
    var body: some View {
        VStack {
            Divider()
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
//                if (self.self.model.taskSteps[self.taskID!] == nil) {
//                    Text("No instructions and steps found!")
//                    Spacer()
//                }
//                else {
                ScrollView([.vertical]) {
                    VStack(alignment: .leading) {
                        HStack (){
                            Circle()
                                .foregroundColor(Color.yellow.opacity(0.9))
                                .frame(width: 40, height: 40)
                                .overlay(Image("")
                                            .resizable()
                                            .frame(width:35, height:35)
                                            .clipShape(Circle())
                                            .padding(0))
                                .overlay(Circle().stroke(Color.red, lineWidth: 1))
                                .shadow(color: .yellow , radius: 4)
                                .padding(EdgeInsets(top: 8, leading: 2, bottom: 0, trailing: 2))
                            Text("Task 1")
                                .font(.system(size: 20, design: .rounded))
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(EdgeInsets(top: 8, leading: 2, bottom: 0, trailing: 2))
                        }.padding(.bottom, 0)
                        HStack {
                            Text("Start:").font(.system(size: 15.0, design: .rounded)).foregroundColor(.green)

                            Text("01:00 PM").font(.system(size: 18.0, design: .rounded))
                        }
                        HStack {
                            Text("End:  ").font(.system(size: 15.0, design: .rounded)).foregroundColor(.red)

                            Text("01:30 PM").font(.system(size: 18.0, design: .rounded))
                        }
                        Text("Takes 20 minutes").font(.system(size: 16.0, design: .rounded)).frame(maxWidth: geo.size.width, alignment: .center).padding(.top, 5)
                    }
                    StepView(name: "Step 1")
                    StepView(name: "Step 1")
                    StepView(name: "Step 2")
                    StepView(name: "Step 3")
                    StepView(name: "Step 4")
                    StepView(name: "Step 5")
                }.frame(height: geo.size.height).padding(0)
//                    ForEach(self.model.taskSteps[self.taskID!]!!, id: \.mapValue.fields.title.stringValue) { item in
//                        VStack(alignment: .leading) {
//                            if item.mapValue.fields.isAvailable.booleanValue {
//                                HStack {
//                                    Text(item.mapValue.fields.title.stringValue)
//                                }
//                            }
//                        }.onTapGesture {
//                            print("Step ID: ")
//                            print(item.mapValue.fields.id.stringValue)
//                        }
//                    }
//                }
            }.navigationBarTitle("Instructions")
        }
    }
}

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView()
    }
}
