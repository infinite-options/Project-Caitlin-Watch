//
//  UserDay.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/24/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation

class UserDay: ObservableObject {
    
    static let shared = UserDay()
    
    @Published var User = "DxYAdlHGfnOve7soXl8k"
    
    @Published var UserDayData = [UserDayGoalEventList]()
  
    @Published var navBar = "MyDay  (" +  TimeZone.current.abbreviation()! + ")"
    
    private init(){}
    
    func mergeSortedGoalsEvents(goals: [Value]?, events: [Event]?) {
        var i=0
        var j=0
        
        var calendar = Calendar.current
        calendar.timeZone = .current
        while i<events?.count ?? -1 && j<goals?.count ?? -1 {
           let eventStart = calendar.dateComponents([.hour, .minute, .second], from: ISO8601DateFormatter().date(from: (events![i].start?.dateTime)!)!)
           let goalStart = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (goals![j].mapValue?.fields.startDayAndTime.stringValue)!)!)
           
           //print(eventStart)
           //print(goalStart)
           
           if calendar.date(from: eventStart)! < calendar.date(from: goalStart)! {
               self.UserDayData.append(events![i])
               i += 1
           } else {
               if goals![j].mapValue!.fields.isDisplayedToday.booleanValue == true {
                   self.UserDayData.append(goals![j])
               }
               j += 1
           }
       }
       
       while i<events?.count ?? -1 {
           self.UserDayData.append(events![i])
           i += 1
       }
       
       while j<goals?.count ?? -1 {
           if goals![j].mapValue!.fields.isDisplayedToday.booleanValue == true {
               self.UserDayData.append(goals![j])
           }
           j += 1
       }
    }
}
