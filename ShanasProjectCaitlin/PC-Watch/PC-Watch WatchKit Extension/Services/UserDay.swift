//
//  UserDay.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/24/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation

class UserDay: ObservableObject {
    
    private static var _shared: UserDay?
    
    static var shared: UserDay{
        if let initializedShared = _shared {
            return initializedShared
        }
        fatalError("Not initialized yet")
    }
    
    @Published var UserDayData = [UserDayGoalEventList]()
    
    var events: [Event]?
    var goals: [Value]?
    
    private init(withGoals goals: [Value], withEvents events: [Event]) {
        self.goals = goals
        self.events = events
    }
    
    class func setup(withGoals goals: [Value], withEvents events: [Event]) {
        _shared = UserDay(withGoals: goals, withEvents: events )
    }
    
    
    func mergeSortedGoalsEvents() {
        var i=0
        var j=0
        
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        while i<self.events?.count ?? -1 && j<self.goals?.count ?? -1{
            let eventStart = calendar.dateComponents([.hour, .minute, .second], from: ISO8601DateFormatter().date(from: (self.events![i].start?.dateTime)!)!)
            let goalStart = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (self.goals![j].mapValue?.fields.startDayAndTime.stringValue)!)!)
            
            print(eventStart)
            print(goalStart)
            
            if calendar.date(from: eventStart)! < calendar.date(from: goalStart)! {
                print(calendar.date(from: eventStart))
                print(calendar.date(from: goalStart))
                self.UserDayData.append(self.events![i])
                i += 1
            }
            else{
                print(calendar.date(from: eventStart))
                print(calendar.date(from: goalStart))
                self.UserDayData.append(self.goals![j])
                j += 1
            }
        }
        
        while i<self.events?.count ?? -1 {
            self.UserDayData.append(self.events![i])
            i += 1
        }
        
        while j<self.goals?.count ?? -1 {
            self.UserDayData.append(self.goals![j])
            j += 1
        }
    }
}
