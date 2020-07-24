//
//  BackgroundServices.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/6/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation
import Combine
import WatchKit

class BackgroundService: NSObject {
    static let shared = BackgroundService()
    let model = FirebaseGoogleService.shared
    
    static let url = URL(string: "https://firestore.googleapis.com/v1/projects/project-caitlin-c71a9/databases/(default)/documents/users/VzYNSZMGGRrtzm74zPmM")!
    
    // Store tasks in order to complete them when finished
    var pendingBackgroundTasks = [WKURLSessionRefreshBackgroundTask]()
    
    func updateContent(completion: () -> ()) {
        let configuration = URLSessionConfiguration
            .background(withIdentifier: "complicationUpdate")
        
        let session = URLSession(configuration: configuration,
                                 delegate: self, delegateQueue: nil)
        
        let backgroundTask = session.downloadTask(with: BackgroundService.url)
        backgroundTask.resume()
    }
    
    func handleDownload(_ backgroundTask: WKURLSessionRefreshBackgroundTask) {
        let configuration = URLSessionConfiguration
            .background(withIdentifier: backgroundTask.sessionIdentifier)
        
        let _ = URLSession(configuration: configuration,
                           delegate: self, delegateQueue: nil)
        
        pendingBackgroundTasks.append(backgroundTask)
    }
}

extension BackgroundService : URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        
        processFile(file: location)
        
        self.pendingBackgroundTasks.forEach {
            $0.setTaskCompletedWithSnapshot(false)
        }
    }
    
    func processFile(file: URL){
        if let data = try? Data(contentsOf: file),
            let model = try? JSONDecoder().decode(Firebase.self, from: data) {
                //data?.fields.goalsRoutines.arrayValue.values ?? nil
            FirebaseGoogleService.shared.data = model.fields.goalsRoutines.arrayValue.values
            print("Successsssss :::::::::")
        }
    }
}
