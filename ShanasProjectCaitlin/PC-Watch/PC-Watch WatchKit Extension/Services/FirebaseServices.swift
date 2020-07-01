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
    
    func setNotification(message: String, time: String, title: String, startOrEndTime: String, id: String, tag: Int) {
     
        let start = Obj.timeLeft.date(from: startOrEndTime)
        let timeComp = time.components(separatedBy: ":")
        let minutes = Int(timeComp[1])!
        var identifier = id
        
        content.title = "\(title) about to start!"
        content.body = message
        var notificTriggerDate = Date()
        
        //0 - Before (StartTime - TimeBeforeStart)
        if tag == 0{
            notificTriggerDate = Calendar.current.date(byAdding: .minute, value: -minutes, to: start!)!
            identifier.append("before")
        }
        // 1 - During (TimeAfterStart + StartTime)
        else if tag == 1
        {
            notificTriggerDate = Calendar.current.date(byAdding: .minute, value: minutes, to: start!)!
            identifier.append("during")
        }
        //2 - After (EndTime + TimeAfterEnd)
        else if tag == 2{
            notificTriggerDate = Calendar.current.date(byAdding: .minute, value: minutes, to: start!)!
            identifier.append("after")
        }
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificTriggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
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

class FirebaseServices: ObservableObject {
    
    static let shared = FirebaseServices()
    
    @Published var data: [Value]?
    
    private var task: [ValueTask]?
    private var step: [ValueTask]?
    @Published var goalsSubtasks = [String: [ValueTask]?]()
    @Published var taskSteps = [String: [ValueTask]?]()
    
    private init() {
        getFirebaseData(){
            (data) in self.data = data
            
            if let data = data {
                for goal in data {
                    self.getFirebaseTasks(goalID: goal.mapValue.fields.id.stringValue){
                        (task) in self.task = task
                        
                        if let task = task {
                            self.goalsSubtasks[goal.mapValue.fields.id
                                .stringValue] = task
                        
                            for step in task {
                                self.getFirebaseStep(stepID: step.mapValue.fields.id.stringValue,                  goalID: goal.mapValue.fields.id.stringValue){
                                    
                                    (task) in self.task = task
                                    if let task = task{
                                        self.taskSteps[step.mapValue.fields.id.stringValue] = task
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getFirebaseData(completion: @escaping ([Value]?) -> ()) {
            guard let url = URL(string: "https://firestore.googleapis.com/v1/projects/project-caitlin-c71a9/databases/(default)/documents/users/anaqPz2mmo3tSGU4lgB4") else { return }
            
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                let data = try? JSONDecoder().decode(Firebase.self, from: data!)
                DispatchQueue.main.async {
                    completion(data?.fields.goalsRoutines.arrayValue.values ?? nil)
                }
            }
        .resume()
    }
    
    func getFirebaseTasks(goalID: String, completion: @escaping ([ValueTask]?) -> ()) {
        var TaskUrl = "https://firestore.googleapis.com/v1/projects/project-caitlin-c71a9/databases/(default)/documents/users/anaqPz2mmo3tSGU4lgB4/goals&routines/"
        TaskUrl.append(goalID)
        print(TaskUrl)
        guard let url = URL(string: TaskUrl) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                let data = try? JSONDecoder().decode(FirebaseTask.self, from: data!)
                DispatchQueue.main.async {
                    completion(data?.fields.actionsTasks.arrayValue.values ?? nil)
                }
            }
        .resume()
    }
    
    func getFirebaseStep(stepID: String, goalID: String, completion: @escaping ([ValueTask]?) -> ()) {
        var StepUrl = "https://firestore.googleapis.com/v1/projects/project-caitlin-c71a9/databases/(default)/documents/users/anaqPz2mmo3tSGU4lgB4/goals&routines/"
        StepUrl.append(goalID)
        StepUrl.append("/actions&tasks/")
        StepUrl.append(stepID)
        print(StepUrl)
        guard let url = URL(string: StepUrl) else { return }
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                let data = try? JSONDecoder().decode(FirebaseStep.self, from: data!)
                DispatchQueue.main.async {
                    completion(data?.fields.instructionsSteps.arrayValue.values ?? nil)
                }
            }
        .resume()
    }
}
