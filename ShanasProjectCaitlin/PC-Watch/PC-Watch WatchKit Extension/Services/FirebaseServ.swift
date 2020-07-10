//
//  FirebaseServ.swift
//  PC-Watch WatchKit Extension
//
//  Created by Shana Duchin on 5/9/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation

class FirebaseServ: ObservableObject {
    
    //update to get events, mimic FirebaseServices
    static let shared = FirebaseServ()
    private let notificationHandler = NotificationHandler()
    
    @Published var events: [Value]?
    
    func getFirebaseData(completion: @escaping ([Values]) -> ()) {
        guard let url = URL(string: "https://firestore.googleapis.com/v1/projects/project-caitlin-c71a9/databases/(default)/documents/users/VzYNSZMGGRrtzm74zPmM/day_events") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let format = try! JSONDecoder().decode(Firebase2.self, from: data!)
            let items = format.documents?.map{$0.fields.dayEvent.arrayValue.values}
            let joined = Array(arrayLiteral: items?.joined())
            print(joined)
            DispatchQueue.main.async {
//                    completion(joined)
            }
        }
        .resume()
    }
}
