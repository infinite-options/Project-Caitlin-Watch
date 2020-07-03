//
//  NotificationHandler.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/2/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationHandler : NSObject, UNUserNotificationCenterDelegate {
    
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    
    
    func setNotification(message: String, time: String, title: String, startOrEndTime: String, id: String, tag: Int) {
        
        let start = DayDateObj.timeLeft.date(from: startOrEndTime)
        let timeComp = time.components(separatedBy: ":")
        let minutes = Int(timeComp[1])!
        var identifier = id
        
        var notificTriggerDate = Date()
        
        //0 - Before (StartTime - TimeBeforeStart)
        if tag == 0{
            notificTriggerDate = Calendar.current.date(byAdding: .minute, value: -minutes, to: start!)!
            identifier.append(" - before")
            content.title = "About to start! \(title)"
            content.body = message
            
        }
        // 1 - During (TimeAfterStart + StartTime)
        else if tag == 1
        {
            notificTriggerDate = Calendar.current.date(byAdding: .minute, value: minutes, to: start!)!
            identifier.append(" - during")
            content.title = "Currently going on: \(title)"
            content.body = message
        }
        //2 - After (EndTime + TimeAfterEnd)
        else if tag == 2{
            notificTriggerDate = Calendar.current.date(byAdding: .minute, value: minutes, to: start!)!
            identifier.append(" - after")
            content.title = "Just finished: \(title)"
            content.body = message
        }
        
        content.sound = UNNotificationSound.default
        
        if (notificTriggerDate > Date()) {
            print("Current request: \(title) + \(identifier) + \(notificTriggerDate)")
            
            checkPendingNotifications(notificDate: notificTriggerDate, identifier: identifier) {(flag) in
                if !(flag) {
                    print("Notification already exists... Exiting!")
                    return
                }
                else {

                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificTriggerDate)
                    print("Date as components:  \(dateComponents)")
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    let request = UNNotificationRequest(identifier: identifier, content: self.content, trigger: trigger)
                    
                    self.center.add(request) { (err) in
                        if let error = err {
                            print(error.localizedDescription)
                        }
                        else {
                            print("successful notification")
                        }
                    }
                }
            }
        }
    }
    
    func checkPendingNotifications(notificDate: Date, identifier: String, completion: @escaping (Bool) -> ()){
        center.getPendingNotificationRequests { (notifications) in
            print("Count: \(notifications.count)")
           
            for item in notifications {
                if let trigger = item.trigger as? UNCalendarNotificationTrigger,
                    let nextTriggerDate = trigger.nextTriggerDate() {
                        print(nextTriggerDate)
                }
                if item.identifier == identifier {
                    print("Ooooopssss.")
                    completion(false)
                }
            }
        }
        completion(true)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("here2")
        completionHandler([.alert, .sound, .badge])
    }
}
