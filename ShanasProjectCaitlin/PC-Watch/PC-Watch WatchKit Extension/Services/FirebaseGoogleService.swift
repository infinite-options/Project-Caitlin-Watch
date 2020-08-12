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
    let UserDayData = UserDay.shared
    
    //Stores the goals and routines
    @Published var data: [Value]?
    
    //Stores the events
    @Published var events: [Event]?
    
    //Temporary variables to hold tasks and steps
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
    
    @Published var isMustDoTasks = [String: Int]()
//    @Published var isMustDoSteps = [String: Int]()
    
    private init() {
//        updateDataModel {
//            print("Populated data model")
//            self.UserDayData.mergeSortedGoalsEvents(goals: self.data ?? [Value](), events: self.events ?? [Event]())
//            self.UserDayData.loadingUser = false
//            NotificationHandler().scheduleNotifications()
//        }
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
        
        group.notify(queue: DispatchQueue.main){
            self.getFirebaseData(){
                
                (data) in self.UserDayData.UserInfo = data!
                self.data = data!.fields.goalsRoutines.arrayValue.values
                
                if let data = self.data {
                    self.data!.sort(by: self.sortGoals)
                    for goal in data {
                        group.enter()
                        self.getFirebaseTasks(goalID: (goal.mapValue!.fields.id.stringValue)){
                            (tasks) in self.tasks = tasks
                            if let tasks = tasks {
                                self.goalsSubtasks[goal.mapValue!.fields.id.stringValue] = tasks
                                self.goalSubtasksLeft[goal.mapValue!.fields.id.stringValue] = tasks.count
                                self.isMustDoTasks[goal.mapValue!.fields.id.stringValue] = 0
                                for task in tasks {
                                    if task.mapValue.fields.isComplete?.booleanValue == true {
                                        self.goalSubtasksLeft[goal.mapValue!.fields.id.stringValue]! -= 1
                                    }
                                    if task.mapValue.fields.isMustDo?.booleanValue == true {
                                        self.isMustDoTasks[goal.mapValue!.fields.id.stringValue]! += 1
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
//                                                if step.mapValue.fields.isMustDo?.booleanValue == true {
//                                                    self.isMustDoSteps[task.mapValue.fields.id.stringValue]! += 1
//                                                }
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
    }
    
    func getEventsFromGoogleCalendar(completion: @escaping ([Event]?) -> ()){
        guard let url = URL(string: "https://us-central1-myspace-db.cloudfunctions.net/GetEventsForTheDay") else { return }
        
        //Get the components for today's date
        var currComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())

        //Set to 00:00:00 for 'start' of the day
        currComponents.hour = 0
        currComponents.minute = 0
        currComponents.second = 0
        let startDate = DayDateObj.ISOFormatter.string(from: Calendar.current.date(from: currComponents)!)
        
        //Set to 23:59:59 for 'end' of the day
        currComponents.hour = 23
        currComponents.minute = 59
        currComponents.second = 59
        let endDate = DayDateObj.ISOFormatter.string(from: Calendar.current.date(from: currComponents)!)
        
        //Create request the body
        let jsonData = getEventsBody(id: self.UserDayData.User,
                                     start: startDate,
                                     end: endDate)
        let finalJsonData = try? JSONEncoder().encode(jsonData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalJsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        print("Getting data now.")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Generic networking error: \(error)")
            }
            if let data = data {
                do {
                    let data = try JSONDecoder().decode([Event].self, from: data)
                    DispatchQueue.main.async {
                        completion(data)
                    }
                }
                catch _ {
                    //print("No events found for user: \(self.UserDayData.User)")
                    //print("Error in parsing Events data: \(jsonParseError)" )
                    completion(nil)
                }
            }
        }
        .resume()
    }
    
    func getFirebaseData(completion: @escaping (Firebase?) -> ()) {
        var goalUrl = "https://firestore.googleapis.com/v1/projects/myspace-db/databases/(default)/documents/users/"
        goalUrl.append(self.UserDayData.User)
        
        guard let url = URL(string: goalUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Generic networking error: \(error)")
            }
            
            if let data = data {
                do {
                    let data = try JSONDecoder().decode(Firebase.self, from: data)
                    DispatchQueue.main.async {
                        completion(data)
                    }
                }
                catch _ {
                    //print("No goals found for user: \(self.UserDayData.User)")
                    //print("Error in parsing Goals data: \(jsonParseError)")
                    completion(nil)
                }
            }
        }
        .resume()
    }
    
    func getFirebaseTasks(goalID: String, completion: @escaping ([ValueTask]?) -> ()) {
        let TaskUrl = "https://firestore.googleapis.com/v1/projects/myspace-db/databases/(default)/documents/users/" + self.UserDayData.User + "/goals&routines/" + goalID
        guard let url = URL(string: TaskUrl) else { return }
        
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    print("Generic networking error: \(error)")
                }
                
                if let data = data {
                    do {
                        let data = try JSONDecoder().decode(FirebaseTask.self, from: data)
                        DispatchQueue.main.async {
                            completion(data.fields.actionsTasks.arrayValue.values)
                        }
                    }
                    catch _ {
                        //print("No tasks for goal: \(goalID)")
                        //print("Error in parsing Tasks data: \(jsonParseError)" )
                        completion(nil)
                    }
                }
            }
        .resume()
    }
    
    func getFirebaseStep(stepID: String, goalID: String, completion: @escaping ([ValueTask]?) -> ()) {
        let StepUrl = "https://firestore.googleapis.com/v1/projects/myspace-db/databases/(default)/documents/users/" + self.UserDayData.User + "/goals&routines/" + goalID + "/actions&tasks/" + stepID
        guard let url = URL(string: StepUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Generic networking error: \(error)")
            }
            
            if let data = data {
                do {
                    let data = try JSONDecoder().decode(FirebaseStep.self, from: data)
                    DispatchQueue.main.async {
                        completion(data.fields.instructionsSteps.arrayValue.values)
                    }
                }
                catch _ {
                    //print("No steps for task: \(stepID)")
                    //print("Error in parsing Steps data: \(jsonParseError)" )
                    completion(nil)
                }
            }
        }
        .resume()
    }
    
    func startGoalOrRoutine(userId: String, routineId: String, taskId: String?, routineNumber: Int?, taskNumber: Int?, stepNumber: Int?) {
        guard let url = URL(string: "https://us-central1-project-caitlin-c71a9.cloudfunctions.net/StartGoalOrRoutine") else { return }
        
        let jsonData = StartCompleteGRATISBody(data: Fields(userId: userId,
                                                    routineId: routineId,
                                                    taskId: taskId,
                                                    routineNumber: routineNumber,
                                                    taskNumber: taskNumber,
                                                    stepNumber: stepNumber
                                                    ))
        let finalJsonData = try? JSONEncoder().encode(jsonData)
        
        var request = URLRequest(url: url)
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
    
    func startActionOrTask(userId: String, routineId: String, taskId: String?, routineNumber: Int?, taskNumber: Int?, stepNumber: Int?) {
        
        guard let url = URL(string: "https://us-central1-project-caitlin-c71a9.cloudfunctions.net/StartActionOrTask") else { return }
        
        let jsonData = StartCompleteGRATISBody(data: Fields(userId: userId,
                                                    routineId: routineId,
                                                    taskId: taskId,
                                                    routineNumber: routineNumber,
                                                    taskNumber: taskNumber,
                                                    stepNumber: stepNumber
                                                    ))
        let finalJsonData = try? JSONEncoder().encode(jsonData)
        
        var request = URLRequest(url: url)
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
    
    func startInstructionOrStep(userId: String, routineId: String, taskId: String?, routineNumber: Int?, taskNumber: Int?, stepNumber: Int?) {
        
        guard let url = URL(string: "https://us-central1-project-caitlin-c71a9.cloudfunctions.net/StartInstructionOrStep") else { return }
        
        let jsonData = StartCompleteGRATISBody(data: Fields(userId: userId,
                                                    routineId: routineId,
                                                    taskId: taskId,
                                                    routineNumber: routineNumber,
                                                    taskNumber: taskNumber,
                                                    stepNumber: stepNumber
                                                    ))
        let finalJsonData = try? JSONEncoder().encode(jsonData)
        
        var request = URLRequest(url: url)
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
    
    func completeGoalOrRoutine(userId: String, routineId: String, taskId: String?, routineNumber: Int?, taskNumber: Int?, stepNumber: Int?) {
        
        guard let url = URL(string: "https://us-central1-project-caitlin-c71a9.cloudfunctions.net/CompleteGoalOrRoutine") else { return }
        
        let jsonData = StartCompleteGRATISBody(data: Fields(userId: userId,
                                                    routineId: routineId,
                                                    taskId: taskId,
                                                    routineNumber: routineNumber,
                                                    taskNumber: taskNumber,
                                                    stepNumber: stepNumber
                                                    ))
        let finalJsonData = try? JSONEncoder().encode(jsonData)
        
        var request = URLRequest(url: url)
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
    
    func completeActionOrTask(userId: String, routineId: String, taskId: String?, routineNumber: Int?, taskNumber: Int?, stepNumber: Int?) {
        
        guard let url = URL(string: "https://us-central1-project-caitlin-c71a9.cloudfunctions.net/CompleteActionOrTask") else { return }
        
        let jsonData = StartCompleteGRATISBody(data: Fields(userId: userId,
                                                    routineId: routineId,
                                                    taskId: taskId,
                                                    routineNumber: routineNumber,
                                                    taskNumber: taskNumber,
                                                    stepNumber: stepNumber
                                                    ))
        let finalJsonData = try? JSONEncoder().encode(jsonData)
        
        var request = URLRequest(url: url)
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
    
    func completeInstructionOrStep(userId: String, routineId: String, taskId: String?, routineNumber: Int?, taskNumber: Int?, stepNumber: Int?) {
        
        guard let url = URL(string: "https://us-central1-project-caitlin-c71a9.cloudfunctions.net/CompleteInstructionOrStep") else { return }
        
        let jsonData = StartCompleteGRATISBody(data: Fields(userId: userId,
                                                    routineId: routineId,
                                                    taskId: taskId,
                                                    routineNumber: routineNumber,
                                                    taskNumber: taskNumber,
                                                    stepNumber: stepNumber
                                                    ))
        let finalJsonData = try? JSONEncoder().encode(jsonData)
        
        var request = URLRequest(url: url)
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
