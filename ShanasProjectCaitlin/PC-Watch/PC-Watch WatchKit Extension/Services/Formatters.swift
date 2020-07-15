//
//  Formatters.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 6/30/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation

var DayDateObj = DayDate()

class DayDate {
    var dueDate = Date()
    let weekday = Calendar.current.component(.weekday, from: Date())
    var day = ["","SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("d")
        return formatter
    }()
    
    let timeLeft: DateFormatter = {
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        //formatter2.dateFormat = "dd MM yyyy'T'HH:mm:ss'Z'"
        return formatter2
    }()
    
    func getTimeLeft(givenDate:String) -> TimeInterval{
        let fromDate = timeLeft.date(from: timeLeft.string(from: Date()))!
        let toDate = timeLeft.date(from: givenDate)!
        print(toDate)
        print(fromDate)
        var delta = toDate.timeIntervalSince(fromDate)
        print(delta)
        if delta < 0.0{
            return 0.0
        }
        else{
            delta = delta/60
            return delta
        }
    }
}
