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
    
    @Published var User = "GdT7CRXUuDXmteS4rQwN"
    
    @Published var UserDayData = [UserDayGoalEventList]()
    
    @Published var UserDayBlockData = [UserDayGoalEventList]()
  
    @Published var navBar = "MyDay  (" +  TimeZone.current.abbreviation()! + ")"
    
    private init(){}
    
    func mergeSortedGoalsEvents(goals: [Value]?, events: [Event]?) {
        var i=0
        var j=0
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        let startInterval = Date()
        let endInterval = Date().addingTimeInterval(240*60)
        
        let startComp = calendar.dateComponents([.year, .month, .day], from: startInterval)
        let endComp = calendar.dateComponents([.year, .month, .day], from: endInterval)
        
        while i<events?.count ?? -1 && j<goals?.count ?? -1 {
            let eventStart = calendar.dateComponents([.hour, .minute, .second], from: ISO8601DateFormatter().date(from: (events![i].start?.dateTime)!)!)
            
            var goalStart = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (goals![j].mapValue?.fields.startDayAndTime.stringValue)!)!)
                goalStart.year = startComp.year
                goalStart.month = startComp.month
                goalStart.day = startComp.day
            
            var goalEnd = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (goals![j].mapValue?.fields.endDayAndTime.stringValue)!)!)
                goalEnd.year = endComp.year
                goalEnd.month = endComp.month
                goalEnd.day = endComp.day
               
            if calendar.date(from: eventStart)! < calendar.date(from: goalStart)! {
                if self.isNow(item: events![i]) == true {
                   self.UserDayData.append(events![i])
                    if self.eventWithinInterval(item: events![i], start: startInterval, end: endInterval) {
                        self.UserDayBlockData.append(events![i])
                    }
                }
                i += 1
            } else {
                if goals![j].mapValue!.fields.isDisplayedToday.booleanValue == true && goals![j].mapValue!.fields.isAvailable.booleanValue == true {
                    self.UserDayData.append(goals![j])
                    if self.goalWithinInterval(itemStart: calendar.date(from: goalStart)!, itemEnd: calendar.date(from: goalEnd)!, start: startInterval, end: endInterval) {
                        self.UserDayBlockData.append(goals![j])
                    }
                }
                j += 1
            }
        }
       
        while i<events?.count ?? -1 {
            if self.isNow(item: events![i]) == true {
                self.UserDayData.append(events![i])
                if self.eventWithinInterval(item: events![i], start: startInterval, end: endInterval) {
                    self.UserDayBlockData.append(events![i])
                }
            }
            i += 1
        }
       
        while j<goals?.count ?? -1 {
            var goalStart = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (goals![j].mapValue?.fields.startDayAndTime.stringValue)!)!)
            goalStart.year = startComp.year
            goalStart.month = startComp.month
            goalStart.day = startComp.day
                
            var goalEnd = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (goals![j].mapValue?.fields.endDayAndTime.stringValue)!)!)
            goalEnd.year = endComp.year
            goalEnd.month = endComp.month
            goalEnd.day = endComp.day
            
            if goals![j].mapValue!.fields.isDisplayedToday.booleanValue == true && goals![j].mapValue!.fields.isAvailable.booleanValue == true {
                self.UserDayData.append(goals![j])
                if self.goalWithinInterval(itemStart: calendar.date(from: goalStart)!, itemEnd: calendar.date(from: goalEnd)!, start: startInterval, end: endInterval) {
                    self.UserDayBlockData.append(goals![j])
                }
           }
           j += 1
       }
    }
    
    private func isNow(item: Event) -> Bool {
        if DayDateObj.ISOFormatter.date(from: item.end!.dateTime)! < Date() {
            return false
        }
        return true
    }
    
    private func eventWithinInterval(item: Event, start: Date, end: Date) -> Bool {
        if DayDateObj.ISOFormatter.date(from: item.end!.dateTime)! < start ||
            DayDateObj.ISOFormatter.date(from: item.start!.dateTime)! > end {
            return false
        }
        return true
    }
    
    private func goalWithinInterval(itemStart: Date, itemEnd: Date, start: Date, end: Date) -> Bool {
        if itemEnd < start || itemStart > end {
            return false
        }
        return true
    }
}
