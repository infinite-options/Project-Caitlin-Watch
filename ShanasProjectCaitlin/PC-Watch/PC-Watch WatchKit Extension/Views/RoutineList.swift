//
//  RoutineList.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/8/20.
//  Updated by Shana Duchin in 4/11/20 and onward
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct RoutineList: View {
    @ObservedObject private var model = FirebaseServices.shared
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                /*
                VStack {
                    Text("\(DayDateObj.day[DayDateObj.weekday]), \(DayDateObj.dueDate, formatter: DayDateObj.taskDateFormat)")
                        .font(.system(size: 15.0, design: .rounded))
                }.frame(maxWidth: geo.size.width, alignment: .leading)
                    
                Text("Routines").foregroundColor(Color.red)
                    .font(.system(.headline, design: .rounded))
                Spacer()
                */
                if(self.model.data == nil){
                    Text("No Routines found!")
                    Spacer()
                }
                else {
                    List {
                        ForEach(self.model.data!.filter{$0.mapValue.fields.isPersistent.booleanValue}, id: \.mapValue.fields.id.stringValue) { item in
                            VStack(alignment: .leading) {
                                if item.mapValue.fields.isAvailable.booleanValue {
                                    if item.mapValue.fields.photo.stringValue != "" {
                                        HStack {
                                            AsyncImage(
                                                url: URL(string: item.mapValue.fields.photo.stringValue)!,
                                                placeholder: Image("blacksquare")
                                                ).aspectRatio(contentMode: .fit)
                                            Text(item.mapValue.fields.title.stringValue)
                                        }
                                    }
            //                            else {
            //                                HStack {
            //                                    Image("blacksquare")
            //                                    .resizable()
            //                                    .frame(width: 30, height: 30)
            //                                    .clipShape(Circle())
            //                                    .overlay(Circle().stroke(Color.white, lineWidth: 0.5))
            //                                    .shadow(radius: 10)
            //                                    .padding(EdgeInsets(top: 10, leading: -1, bottom: 10, trailing: 1.5))
            //                                    Text(item.mapValue.fields.title.stringValue)
            //                                }
            //
            //                            }
            //
                                    }
                                }
                            }
                        }
                }
                //PersistentView(goal: true, event: true, routine: false, help: true)
            }.edgesIgnoringSafeArea(.bottom).padding(0)
        }
    }
}

struct RoutineList_Previews: PreviewProvider {
    static var previews: some View {
        RoutineList()
    }
}
