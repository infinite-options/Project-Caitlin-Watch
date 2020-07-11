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
}
