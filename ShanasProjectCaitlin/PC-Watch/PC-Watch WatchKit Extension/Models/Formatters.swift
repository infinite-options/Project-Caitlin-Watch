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
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        formatter.timeZone = .current
        print(formatter.timeZone!)
        return formatter
    }()
    
    let formatter: DateFormatter = {
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "h:mm a"
        return format
    }()

    let durationFormatter: DateFormatter = {
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "h:mm"
        return format
    }()
    
}
