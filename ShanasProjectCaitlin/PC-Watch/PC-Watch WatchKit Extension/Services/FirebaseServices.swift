//
//  FirebaseServices.swift
//  WatchLandmarks Extension
//
//  Created by Kyle Hoefer on 3/25/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class FirebaseServices{
    
    func getFirebaseData(completion: @escaping ([Value]) -> ()) {
            guard let url = URL(string: "https://firestore.googleapis.com/v1/projects/project-caitlin-c71a9/databases/(default)/documents/users/TuqC2z3ta8dGueJlDS6s") else { return }
            
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                let data = try! JSONDecoder().decode(Firebase.self, from: data!)
                DispatchQueue.main.async {
                    completion(data.fields.goalsRoutines.arrayValue.values)
                }
            }
        .resume()
    }
    
    func getFirebaseTasks(goalID: String, completion: @escaping ([ValueTask]) -> ()) {
        var TaskUrl = "https://firestore.googleapis.com/v1/projects/project-caitlin-c71a9/databases/(default)/documents/users/TuqC2z3ta8dGueJlDS6s/goals&routines/"
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
        "https://firestore.googleapis.com/v1/projects/project-caitlin-c71a9/databases/(default)/documents/users/TuqC2z3ta8dGueJlDS6s/goals&routines/"
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
