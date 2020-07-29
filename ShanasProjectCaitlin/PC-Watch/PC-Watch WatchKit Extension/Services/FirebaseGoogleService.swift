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
    
    @Published var UserDay = [UserDayGoalEventList]()
    
    @Published var data: [Value]?
    @Published var events: [Event]?
    private var task: [ValueTask]?
    //Key: Goal, Value: tasks
    @Published var goalsSubtasks = [String: [ValueTask]?]()
    //Key: Task, Value: steps
    @Published var taskSteps = [String: [ValueTask]?]()
    
    // Key = goalID
    @Published var goalSubtasksLeft = [String: Int]()
    // Key = taskID
    @Published var taskStepsLeft = [String: Int]()
    
    
    private init() {
        updateDataModel {
            print("Populated data model. -------------------------")
            print(self.UserDay.count)
            //if (self.UserDay.count > 1) {
            self.mergeSortedGoalsEvents()
            //UserDay.setup(withGoals: self.data ?? [Value](), withEvents: self.events ?? [Event]())
            //}
            //print(self.UserDay.count)
        }
    }
    
    func mergeSortedGoalsEvents() {
        var i=0
        var j=0
        
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        while i<self.events?.count ?? -1 && j<self.data?.count ?? -1{
            let eventStart = calendar.dateComponents([.hour, .minute, .second], from: ISO8601DateFormatter().date(from: (self.events![i].start?.dateTime)!)!)
            let goalStart = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (self.data![j].mapValue?.fields.startDayAndTime.stringValue)!)!)
            
            print(eventStart)
            print(goalStart)
            
            if calendar.date(from: eventStart)! < calendar.date(from: goalStart)! {
                print(calendar.date(from: eventStart))
                print(calendar.date(from: goalStart))
                self.UserDay.append(self.events![i])
                i += 1
            }
            else{
                print(calendar.date(from: eventStart))
                print(calendar.date(from: goalStart))
                if self.data![j].mapValue!.fields.isDisplayedToday.booleanValue == true {
                    self.UserDay.append(self.data![j])
                }
                j += 1
            }
        }
        
        while i<self.events?.count ?? -1 {
            self.UserDay.append(self.events![i])
            i += 1
        }
        
        while j<self.data?.count ?? -1 {
            if self.data![j].mapValue!.fields.isDisplayedToday.booleanValue == true {
                self.UserDay.append(self.data![j])
            }
            j += 1
        }
    }
 
    func sortGoals(this: Value, that: Value) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        let thisStart = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (this.mapValue?.fields.startDayAndTime.stringValue)!)!)
        let thatStart = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (that.mapValue?.fields.startDayAndTime.stringValue)!)!)
        
        if thisStart == thatStart {
            if that.mapValue?.fields.isPersistent.booleanValue == true {
                return calendar.date(from: thatStart)! < calendar.date(from: thisStart)!
            }
        }
        return calendar.date(from: thisStart)! < calendar.date(from: thatStart)!
    }
    
    func sortEvents(this: Event, that: Event) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        let thisStart = calendar.dateComponents([.hour, .minute, .second], from: ISO8601DateFormatter().date(from: (this.start?.dateTime)!)!)
        let thatStart = calendar.dateComponents([.hour, .minute, .second], from: ISO8601DateFormatter().date(from: (that.start?.dateTime)!)!)
        
        return calendar.date(from: thisStart)! < calendar.date(from: thatStart)!
    }
    
    func updateStepsTasksLeftDictionaries() {
        print("In updateStepsTasksLeftDictionaries...")
        
        self.getFirebaseData(){
            (data) in self.data = data!
            if let data = data {
                self.data!.sort(by: self.sortGoals)
                for goal in data {
                    self.getFirebaseTasks(goalID: (goal.mapValue!.fields.id.stringValue)){
                        (task) in self.task = task
                        if let task = task {
                            self.goalSubtasksLeft[goal.mapValue!.fields.id.stringValue] = task.count
                            for step in task {
                                if step.mapValue.fields.isComplete?.booleanValue == true {
                                    self.goalSubtasksLeft[goal.mapValue!.fields.id.stringValue]! -= 1
                                }
                                self.getFirebaseStep(stepID: step.mapValue.fields.id.stringValue, goalID: goal.mapValue!.fields.id.stringValue){
                                    (task) in self.task = task
                                    if let task = task {
                                        self.taskStepsLeft[step.mapValue.fields.id.stringValue] = task.count
                                        for item in task {
                                            if item.mapValue.fields.isComplete?.booleanValue == true {
                                                self.taskStepsLeft[step.mapValue.fields.id.stringValue]! -=  1
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
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
                //print(self.events)
                self.events?.sort(by: self.sortEvents)
                //for event in data{
                  //  self.UserDay.append(event)
                //}
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main){
            self.getFirebaseData(){
                (data) in self.data = data
                
                if let data = data {
                    self.data!.sort(by: self.sortGoals)
                    
                    for goal in data {
                        group.enter()
                        //self.UserDay.append(goal)
                        self.goalSubtasksLeft[goal.mapValue!.fields.id.stringValue] = 0
                        self.getFirebaseTasks(goalID: (goal.mapValue!.fields.id.stringValue)){
                            (task) in self.task = task
                            if let task = task {
                                self.goalsSubtasks[goal.mapValue!.fields.id.stringValue] = task
                                for step in task {
                                    
                                    group.enter()
                                    self.taskStepsLeft[step.mapValue.fields.id.stringValue] = 0
                                    self.getFirebaseStep(stepID: step.mapValue.fields.id.stringValue, goalID: goal.mapValue!.fields.id.stringValue){
                                        (task) in self.task = task
                                        if let task = task{
                                            self.taskSteps[step.mapValue.fields.id.stringValue] = task
                                        }
                                    }
                                    group.leave()
                                }
                            }
                            group.leave()
                        }
                    }
                    self.updateStepsTasksLeftDictionaries()
                    group.notify(queue: DispatchQueue.main) {
                        completion()
                    }
                }
                else {
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
    
    struct startGRATISbody: Codable {
        var data: Fields
    }
    
    struct Fields: Codable {
        var userId: String
        var routineId: String
        var taskId: String?
        var taskNumber: Int?
        var stepNumber: Int?
    }
    
    struct cloudFuncResp: Decodable {
        var result: Int
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
    
    struct completeGRATISbody: Codable {
        var data: CompleteFields
    }
    
    struct CompleteFields: Codable {
        var userId: String
        var routineId: String
        var taskId: String?
        var routineNumber: Int?
        var taskNumber: Int?
        var stepNumber: Int?
    }
}
