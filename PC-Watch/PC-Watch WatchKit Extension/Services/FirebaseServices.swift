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
            guard let url = URL(string: "https://firestore.googleapis.com/v1/projects/project-caitlin-c71a9/databases/(default)/documents/users/VzYNSZMGGRrtzm74zPmM") else { return }
            
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                let data = try! JSONDecoder().decode(Firebase.self, from: data!)
                DispatchQueue.main.async {
                    completion(data.fields.goalsRoutines.arrayValue.values)
                }
            }
        .resume()
    }
}
