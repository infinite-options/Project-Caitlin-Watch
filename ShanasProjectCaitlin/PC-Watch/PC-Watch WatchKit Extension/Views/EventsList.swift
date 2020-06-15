
//  EventsList.swift
//  PC-Watch WatchKit Extension
//
//  Created by Shana Duchin on 4/11/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI
import Foundation
import UIKit

struct EventsList: View {

    @State var data = [Values]()
   // @State var currentDate = Date()
    @State var formatter = DateFormatter()
    @State var calendar = Calendar.current
    @State var firebaseDate = Date()
    @State var alldata = [Values]()
    
    
   
//    let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
//    let today = Calendar.current.isDateInToday(<#T##date: Date##Date#>)

//        var body: some View {
//            NavigationLink(destination:
//                VStack(alignment: .leading) {
//                        Text("Events")
//                            .bold()
//                        List (data, id: \.mapValue.fields.title.stringValue) { item in
//
//                            firebaseDate = DateFormatter().date(from: item.mapValue.fields.when.timestampValue)!
//                           // if isDate == true {
//                                Text(item.mapValue.fields.title.stringValue)
//                        //}
//                    }
//                }
//                .onAppear { FirebaseServ().getFirebaseData() { (data) in
//                    self.data = data
//                    }
//                }) {
//                Text("Events")
//                    .frame(height: 50, alignment: .center)
//            }
//        }
//        func isDate(_ date1: Date, inSameDayAs date2: Date) -> Bool {
//            return true
//        }
    var body: some View {
               //NavigationLink(destination:
                   List {
                       ForEach(data, id: \.mapValue.fields.title.stringValue) { item in
                           VStack(alignment: .leading) {
                              //Text(item.mapValue.fields.title.stringValue)
//                               .bold()
//
                               //firebaseDate = DateFormatter().date(from: item.mapValue.fields.when.timestampValue)!
                              // if isDate == true {
                            Text(item.mapValue.fields.title.stringValue)

                           }
                       }
                   }
                   .onAppear { FirebaseServ().getFirebaseData() { (data) in
                    self.config()
                    for item in data {
                        if(self.calendar.isDate(Date(), equalTo: self.formatter.date(from: item.mapValue.fields.when.timestampValue)!, toGranularity:.day) && self.calendar.isDate(Date(), equalTo: self.formatter.date(from: item.mapValue.fields.when.timestampValue)!, toGranularity:.month)) {
                            
                            self.data.append(item)
                        }
                        
                    }
                       }
                   }//) {
                   //Text("Events")
                     //  .frame(height: 50, alignment: .center)
               //}
           }
    
    private func config() {
        self.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    }


}



struct EventsList_Previews: PreviewProvider {
    static var previews: some View {
        EventsList()
    }
}
