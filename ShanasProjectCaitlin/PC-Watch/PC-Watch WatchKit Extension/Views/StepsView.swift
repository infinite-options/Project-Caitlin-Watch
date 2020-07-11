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
    var photo: String
    @State var done = false
    
    var body: some View {
        VStack {
            Divider()
            VStack {
                HStack {
                    AsyncImage(url: URL(string:self.photo)!, placeholder: Image("blacksquare")).aspectRatio(contentMode: .fit)
                    Spacer()
                    Text(name)
                }
                Spacer()
                if(!self.done){
                    Button(action: {
                        buttonAction()
                    }) {
                        Text("Done?").foregroundColor(.green).onTapGesture {
                            print("completed")
                            self.done = true
                        }
                    }
                } else {
                    Text("Done")
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
    var taskID: String?
    var itemID: String?
    var taskName: String?
    var photo: String?
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center) {
                if (self.model.taskSteps[self.taskID!] == nil) {
                    AsyncImage(url: URL(string:self.photo!)!, placeholder: Image("blacksquare")).aspectRatio(contentMode: .fit)
                    Text(self.taskName!)
                    Spacer()
                }
                else {
                    ScrollView([.vertical]) {
                        VStack(alignment: .center) {
                            //TODO: change to image associated with task
                            AsyncImage(url: URL(string:self.photo!)!, placeholder: Image("blacksquare")).aspectRatio(contentMode: .fit)
                            Text(self.taskName!)
                                .font(.system(size: 20, design: .rounded))
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(EdgeInsets(top: 8, leading: 2, bottom: 0, trailing: 2))
                        }.padding(.bottom, 0)
                        ForEach(self.model.taskSteps[self.taskID!]!!, id: \.mapValue.fields.title.stringValue) { item in
                            VStack(alignment: .leading) {
                                if item.mapValue.fields.isAvailable.booleanValue {
                                    StepView(name: item.mapValue.fields.title.stringValue, photo: item.mapValue.fields.photo.stringValue)
    //                                HStack {
    //                                    Text(item.mapValue.fields.title.stringValue)
    //                                }
                                }
                            }
                        }
                    }.frame(height: geo.size.height).padding(0)
                }
            }.navigationBarTitle("Instructions")
        }
    }
}

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView()
    }
}
