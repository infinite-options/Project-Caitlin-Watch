//
//  FirebaseServices.swift
//  WatchLandmarks Extension
//
//  Created by Kyle Hoefer on 3/25/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class FirebaseServices: ObservableObject {
    
    static let shared = FirebaseServices()
    private let notificationHandler = NotificationHandler()
    
    @Published var data: [Value]?
    private var task: [ValueTask]?
    @Published var goalsSubtasks = [String: [ValueTask]?]()
    @Published var taskSteps = [String: [ValueTask]?]()
    
    private init() {
        updateDataModel {
            print("waiting.. done!")
            
            if self.data != nil{
                //print(data)
                print("App initialized.. now setting notifications")
            }
        }
    }
    
    func updateDataModel(completion: @escaping () -> ()) {
        print("In updating model...")
        
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
                                self.getFirebaseStep(stepID: step.mapValue.fields.id.stringValue, goalID: goal.mapValue.fields.id.stringValue){
                                    
                                    (task) in self.task = task
                                    if let task = task{
                                        self.taskSteps[step.mapValue.fields.id.stringValue] = task
                                    }
                                }
                            }
                        }
                    }
                }
                completion()
            }
        }
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
    
}
