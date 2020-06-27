//
//  FirebaseServices.swift
//  WatchLandmarks Extension
//
//  Created by Kyle Hoefer on 3/25/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationHandler : NSObject, UNUserNotificationCenterDelegate {
    var Obj = DayDate()
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    
    func setBeforeNotification(message: String, time: String, title: String, startTime: String) {
     
        let start = Obj.timeLeft.date(from: startTime)
        let timeComp = time.components(separatedBy: ":")
        let minutes = Int(timeComp[1])!
        
        content.title = "\(title) about to start!"
        content.body = message
        
        let notificTriggerDate = Calendar.current.date(byAdding: .minute, value: -minutes, to: start!)!
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificTriggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        var identifier = title
        identifier.append("user-before")
        
        print("BEFORE :: IDENTIFIER = \(identifier) :: TIME = \(notificTriggerDate)")
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (err) in
            if let error = err {
                print(error.localizedDescription)
            }
            else {
                print("successful notification")
            }
        }
    }
    
    func setAfterNotification(message: String, time: String, title: String, endTime: String) {
        let start = Obj.timeLeft.date(from: endTime)
        let timeComp = time.components(separatedBy: ":")
        let minutes = Int(timeComp[1])!
        
        content.title = "Just Finished \(title)"
        content.body = message
        
        let notificTriggerDate = Calendar.current.date(byAdding: .minute, value: minutes, to: start!)!
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificTriggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        var identifier = title
        identifier.append("user-after")
        
        print("AFTER :: IDENTIFIER = \(identifier) :: TIME = \(notificTriggerDate)")
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (err) in
            if let error = err {
                print(error.localizedDescription)
            }
            else {
                print("successful notification")
            }
        }
    }
    
    func setDuringNotification(message: String, time: String, title: String, startTime: String) {
        let start = Obj.timeLeft.date(from: startTime)
        let timeComp = time.components(separatedBy: ":")
        let minutes = Int(timeComp[1])!
        
        content.title = "Currently working on: \(title)"
        content.body = message
        
        let notificTriggerDate = Calendar.current.date(byAdding: .minute, value: minutes, to: start!)!
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificTriggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        var identifier = title
        identifier.append("user-during")
        
        print("DURING :: IDENTIFIER = \(identifier) :: TIME = \(notificTriggerDate)")
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (err) in
            if let error = err {
                print(error.localizedDescription)
            }
            else {
                print("successful notification")
            }
        }
    }
}

class FirebaseServices{
    
    func getFirebaseData(completion: @escaping ([Value]) -> ()) {
            guard let url = URL(string: "https://firestore.googleapis.com/v1/projects/project-caitlin-c71a9/databases/(default)/documents/users/anaqPz2mmo3tSGU4lgB4") else { return }
            
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                let data = try! JSONDecoder().decode(Firebase.self, from: data!)
                DispatchQueue.main.async {
                    completion(data.fields.goalsRoutines.arrayValue.values)
                }
            }
        .resume()
    }
    
    func getFirebaseTasks(goalID: String, completion: @escaping ([ValueTask]) -> ()) {
        var TaskUrl = "https://firestore.googleapis.com/v1/projects/project-caitlin-c71a9/databases/(default)/documents/users/anaqPz2mmo3tSGU4lgB4/goals&routines/"
        TaskUrl.append(goalID)
        print(TaskUrl)
        guard let url = URL(string: TaskUrl) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                let data = try! JSONDecoder().decode(FirebaseTask.self, from: data!)
                DispatchQueue.main.async {
                    completion(data.fields.actionsTasks.arrayValue.values)
                }
            }
        .resume()
    }
    
    func getFirebaseStep(stepID: String, goalID: String, completion: @escaping ([ValueTask]) -> ()) {
        var StepUrl =
        "https://firestore.googleapis.com/v1/projects/project-caitlin-c71a9/databases/(default)/documents/users/anaqPz2mmo3tSGU4lgB4/goals&routines/"
        StepUrl.append(goalID)
        StepUrl.append("/actions&tasks/")
        StepUrl.append(stepID)
        print(StepUrl)
        guard let url = URL(string: StepUrl) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                let data = try! JSONDecoder().decode(FirebaseStep.self, from: data!)
                DispatchQueue.main.async {
                    completion(data.fields.instructionsSteps.arrayValue.values)
                }
            }
        .resume()
    }
    
}
