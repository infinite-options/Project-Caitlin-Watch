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
                    if (self.done) {
                        AsyncImage(url: URL(string:self.photo)!, placeholder: Image("blacksquare")).aspectRatio(contentMode: .fit)
                            .overlay(Image(systemName: "checkmark.circle")
                            .font(.system(size:64))
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                            .foregroundColor(.green))
                    } else {
                        AsyncImage(url: URL(string:self.photo)!, placeholder: Image("blacksquare")).aspectRatio(contentMode: .fit)
                    }
                    Spacer()
                    Text(name)
                }
                Spacer()
                if(!self.done){
                    Button(action: {
                        buttonAction()
                    }) {
                        Text("Done?")
                            .foregroundColor(.green)
                            .onTapGesture {
                                print("completed")
                                self.done = true
                            }
                    }
                } else {
                    Text("Completed")
                        .overlay(RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous).stroke(Color.green, lineWidth: 1).frame(width:120, height:25))
                        .foregroundColor(.green)
                        .foregroundColor(.green)
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
    @State var done = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center) {
                if (self.model.taskSteps[self.taskID!] == nil) {
                    if (self.done){
                        AsyncImage(url: URL(string:self.photo!)!, placeholder: Image("blacksquare")).aspectRatio(contentMode: .fit).opacity(0.60)
                            .overlay(Image(systemName: "checkmark.circle")
                                .font(.system(size:64))
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                                .foregroundColor(.green))
                    } else {
                        AsyncImage(url: URL(string:self.photo!)!, placeholder: Image("blacksquare")).aspectRatio(contentMode: .fit)
                    }
                    Text(self.taskName!).lineLimit(nil).padding().font(.system(size: 20))
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
                        Text("Task Completed").overlay(RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous).stroke(Color.green, lineWidth: 1).frame(width:140, height:25))
                            .foregroundColor(.green)
                    }
                }
                else {
                    ScrollView([.vertical]) {
                        VStack(alignment: .center) {
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
