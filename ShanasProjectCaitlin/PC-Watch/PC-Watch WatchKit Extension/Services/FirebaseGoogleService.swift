//
//  FirebaseServices.swift
//  WatchLandmarks Extension
//
//  Created by Kyle Hoefer on 3/25/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class FirebaseGoogleService: ObservableObject {
    
    static let shared = FirebaseGoogleService()
    //private let notificationHandler = NotificationHandler()
    let UserDayData = UserDay.shared
    //@Published var UserDay = [UserDayGoalEventList]()
    
    @Published var data: [Value]?
    @Published var events: [Event]?
    
    private var tasks: [ValueTask]?
    private var steps: [ValueTask]?
    
    //Key: Goal, Value: tasks
    @Published var goalsSubtasks = [String: [ValueTask]?]()
    //Key: Task, Value: steps
    @Published var taskSteps = [String: [ValueTask]?]()
    
    // Key: Goal, Value: # of tasks in Goal
    @Published var goalSubtasksLeft = [String: Int]()
    // Key: Task, Value: #
    @Published var taskStepsLeft = [String: Int]()
    
    
    private init() {
        updateDataModel {
            print("Populated data model. -------------------------")
            self.UserDayData.mergeSortedGoalsEvents(goals: self.data ?? [Value](), events: self.events ?? [Event]())
        }
    }
    
    func updateDataModel(completion: @escaping () -> ()) {
        print("In updating model...")
        let group = DispatchGroup()
        group.enter()
        getEventsFromGoogleCalendar(){
            (data) in self.events = data
            print("Got events from Google Calendar. Now getting firebase data.")
            if self.events != nil{
                self.events?.sort(by: self.sortEvents)
            }
            group.leave()
        }
        self.getFirebaseData(){
            (data) in self.data = data
            //print("-----------", data)
            if let data = data {
                self.data?.sort(by: self.sortGoals)
                for goal in data {
                    group.enter()
                    self.getFirebaseTasks(goalID: (goal.mapValue!.fields.id.stringValue)){
                        (tasks) in self.tasks = tasks
                        if let tasks = tasks {
                            self.goalsSubtasks[goal.mapValue!.fields.id.stringValue] = tasks
                            self.goalSubtasksLeft[goal.mapValue!.fields.id.stringValue] = tasks.count
                            for task in tasks {
                                if task.mapValue.fields.isComplete?.booleanValue == true {
                                    self.goalSubtasksLeft[goal.mapValue!.fields.id.stringValue]! -= 1
                                }
                                group.enter()
                                self.getFirebaseStep(stepID: task.mapValue.fields.id.stringValue, goalID: goal.mapValue!.fields.id.stringValue){
                                    (steps) in self.steps = steps
                                    if let steps = steps{
                                        self.taskSteps[task.mapValue.fields.id.stringValue] = steps
                                        self.taskStepsLeft[task.mapValue.fields.id.stringValue] = steps.count
                                        for step in steps {
                                            if step.mapValue.fields.isComplete?.booleanValue == true {
                                                self.taskStepsLeft[task.mapValue.fields.id.stringValue]! -=  1
                                            }
                                        }
                                    }
                                }
                                group.leave()
                            }
                        }
                        group.leave()
                    }
                }
                group.notify(queue: DispatchQueue.main) {
                    completion()
                }
            }
        }
    }

    func getEventsFromGoogleCalendar(completion: @escaping ([Event]?) -> ()){
        print("Getting data now.")
        guard let url = URL(string: "https://manifestmy.space/getEventsByInterval?start=2020-07-24T00:00:00Z&end=2020-07-24T23:59:59Z&id=GdT7CRXUuDXmteS4rQwN&name=Emma%20Allegrucci") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let data = try? JSONDecoder().decode([Event].self, from: data!)
            DispatchQueue.main.async {
                completion(data ?? nil)
            }
        }
        .resume()
    }
    
    func getFirebaseData(completion: @escaping ([Value]?) -> ()) {
        guard let url = URL(string: "https://firestore.googleapis.com/v1/projects/myspace-db/databases/(default)/documents/users/GdT7CRXUuDXmteS4rQwN/") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let data = try? JSONDecoder().decode(Firebase.self, from: data!)
            DispatchQueue.main.async {
                completion(data?.fields.goalsRoutines.arrayValue.values ?? nil)
            }
        }
        .resume()
    }
    
    func getFirebaseTasks(goalID: String, completion: @escaping ([ValueTask]?) -> ()) {
        var TaskUrl = "https://firestore.googleapis.com/v1/projects/myspace-db/databases/(default)/documents/users/GdT7CRXUuDXmteS4rQwN/goals&routines/"
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
        var StepUrl = "https://firestore.googleapis.com/v1/projects/myspace-db/databases/(default)/documents/users/GdT7CRXUuDXmteS4rQwN/goals&routines/"
        StepUrl.append(goalID)
        StepUrl.append("/actions&tasks/")
        StepUrl.append(stepID)
        //print(StepUrl)
        guard let url = URL(string: StepUrl) else { return }
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                let data = try? JSONDecoder().decode(FirebaseStep.self, from: data!)
                DispatchQueue.main.async {
                    completion(data?.fields.instructionsSteps.arrayValue.values ?? nil)
                }
            }
        .resume()
    }
    
    func startGRATIS(userId: String, routineId: String, taskId: String?, taskNumber: Int?, stepNumber: Int?, start: String){
        
        var url: URL?
        var request: URLRequest
        
        if start == "goal"{
            url = URL(string: "https://us-central1-project-caitlin-c71a9.cloudfunctions.net/StartGoalOrRoutine")
        }
        if start == "task"{
           url = URL(string: "https://us-central1-project-caitlin-c71a9.cloudfunctions.net/StartActionOrTask")
        }
        if start == "step"{
            url = URL(string: "https://us-central1-project-caitlin-c71a9.cloudfunctions.net/StartInstructionOrStep")
        }
        
        let jsonData = startGRATISbody(data: Fields(userId: userId,
                                                    routineId: routineId,
                                                    taskId: taskId,
                                                    taskNumber: taskNumber,
                                                    stepNumber: stepNumber
                                                    ))
        
        let finalJsonData = try? JSONEncoder().encode(jsonData)
        if let url = url { request = URLRequest(url: url) }
        else { return }
        
        request.httpMethod = "POST"
        request.httpBody = finalJsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request){ (data, _ , error) in
            if let error = error {
                print("Generic networking error: \(error)")
            }
            
            if let data = data {
                do{
                    let finalRespData = try JSONDecoder().decode(cloudFuncResp.self, from: data)
                    print(finalRespData)
                }
                catch let jsonParseError {
                    print("Error in parsing JSON response: \(jsonParseError)")
                }
            }
            else { return }
        }.resume()
    }
    
    func completeGRATIS(userId: String, routineId: String, taskId: String?, routineNumber: Int?, taskNumber: Int?, stepNumber: Int?, start: String){
        
        var url: URL?
        var request: URLRequest
        
        if start == "goal"{
            url = URL(string: "https://us-central1-project-caitlin-c71a9.cloudfunctions.net/CompleteGoalOrRoutine")
        }
        if start == "task"{
           url = URL(string: "https://us-central1-project-caitlin-c71a9.cloudfunctions.net/CompleteActionOrTask")
        }
        if start == "step"{
            url = URL(string: "https://us-central1-project-caitlin-c71a9.cloudfunctions.net/CompleteInstructionOrStep")
        }
        
        let jsonData = completeGRATISbody(data: CompleteFields(userId: userId,
                                                    routineId: routineId,
                                                    taskId: taskId,
                                                    routineNumber: routineNumber,
                                                    taskNumber: taskNumber,
                                                    stepNumber: stepNumber
                                                    ))
        
        let finalJsonData = try? JSONEncoder().encode(jsonData)
        if let url = url { request = URLRequest(url: url) }
        else { return }
        
        request.httpMethod = "POST"
        request.httpBody = finalJsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request){ (data, _ , error) in
            if let error = error {
                print("Generic networking error: \(error)")
            }
            
            if let data = data {
                do{
                    let finalRespData = try JSONDecoder().decode(cloudFuncResp.self, from: data)
                    print(finalRespData)
                }
                catch let jsonParseError {
                    print("Error in parsing JSON response: \(jsonParseError)")
                }
            }
            else { return }
        }.resume()
    }

   func sortGoals(this: Value, that: Value) -> Bool {
       var calendar = Calendar.current
       calendar.timeZone = .current
       
       let thisStart = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (this.mapValue?.fields.startDayAndTime.stringValue)!)!)
       let thatStart = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (that.mapValue?.fields.startDayAndTime.stringValue)!)!)
       
       return calendar.date(from: thisStart)! < calendar.date(from: thatStart)!
   }
   
   func sortEvents(this: Event, that: Event) -> Bool {
       var calendar = Calendar.current
       calendar.timeZone = .current
       
       let thisStart = calendar.dateComponents([.hour, .minute, .second], from: ISO8601DateFormatter().date(from: (this.start?.dateTime)!)!)
       let thatStart = calendar.dateComponents([.hour, .minute, .second], from: ISO8601DateFormatter().date(from: (that.start?.dateTime)!)!)
       
       return calendar.date(from: thisStart)! < calendar.date(from: thatStart)!
   }
}
