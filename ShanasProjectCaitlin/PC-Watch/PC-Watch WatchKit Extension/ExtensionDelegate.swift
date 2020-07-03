//
//  ExtensionDelegate.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/6/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import WatchKit
import UserNotifications

class ExtensionDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {
    
    
    private let notificationHandler = NotificationHandler()
    
    func applicationDidFinishLaunching() {
        UNUserNotificationCenter.current().delegate = self
        let _ = FirebaseServices.shared
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("User granted permission.")
            }
            else {
                print("Permission not granted")
            }
            
        }
    }

    func applicationDidBecomeActive() {
        let model = FirebaseServices.shared
        model.updateDataModel {
            print("Updating done..")
            
            /*if let data = model.data{
                for item in data{
                    //User - Before
                    if (item.mapValue.fields.userNotifications.mapValue.fields.before.mapValue.fields.isEnabled.booleanValue){
                        self.notificationHandler.setNotification(
                            message: item.mapValue.fields.userNotifications.mapValue.fields.before.mapValue.fields.message.stringValue,
                            time:  item.mapValue.fields.userNotifications.mapValue.fields.before.mapValue.fields.time.stringValue,
                            title: item.mapValue.fields.title.stringValue,
                            startOrEndTime: item.mapValue.fields.startDayAndTime.stringValue,
                            id: item.mapValue.fields.id.stringValue,
                            tag: 0)
                    }
                    //User - During
                    if (item.mapValue.fields.userNotifications.mapValue.fields.during.mapValue.fields.isEnabled.booleanValue){
                        self.notificationHandler.setNotification(
                            message: item.mapValue.fields.userNotifications.mapValue.fields.during.mapValue.fields.message.stringValue,
                            time:  item.mapValue.fields.userNotifications.mapValue.fields.during.mapValue.fields.time.stringValue,
                            title: item.mapValue.fields.title.stringValue,
                            startOrEndTime: item.mapValue.fields.startDayAndTime.stringValue,
                            id: item.mapValue.fields.id.stringValue,
                            tag: 1)
                    }
                    //User - After
                    if (item.mapValue.fields.userNotifications.mapValue.fields.after.mapValue.fields.isEnabled.booleanValue){
                        self.notificationHandler.setNotification(
                            message: item.mapValue.fields.userNotifications.mapValue.fields.after.mapValue.fields.message.stringValue,
                            time:  item.mapValue.fields.userNotifications.mapValue.fields.after.mapValue.fields.time.stringValue,
                            title: item.mapValue.fields.title.stringValue,
                            startOrEndTime: item.mapValue.fields.endDayAndTime.stringValue,
                            id: item.mapValue.fields.id.stringValue,
                            tag: 2)
                        }
                    }
                }*/
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
        if let data = FirebaseServices.shared.data{
            for item in data{
                if (item.mapValue.fields.userNotifications.mapValue.fields.before.mapValue.fields.isEnabled.booleanValue){
                    self.notificationHandler.setNotification(
                        message: item.mapValue.fields.userNotifications.mapValue.fields.before.mapValue.fields.message.stringValue,
                        time:  item.mapValue.fields.userNotifications.mapValue.fields.before.mapValue.fields.time.stringValue,
                        title: item.mapValue.fields.title.stringValue,
                        startOrEndTime: item.mapValue.fields.startDayAndTime.stringValue,
                        id: item.mapValue.fields.id.stringValue,
                        tag: 0)
                }
                //User - During
                if (item.mapValue.fields.userNotifications.mapValue.fields.during.mapValue.fields.isEnabled.booleanValue){
                    self.notificationHandler.setNotification(
                        message: item.mapValue.fields.userNotifications.mapValue.fields.during.mapValue.fields.message.stringValue,
                        time:  item.mapValue.fields.userNotifications.mapValue.fields.during.mapValue.fields.time.stringValue,
                        title: item.mapValue.fields.title.stringValue,
                        startOrEndTime: item.mapValue.fields.startDayAndTime.stringValue,
                        id: item.mapValue.fields.id.stringValue,
                        tag: 1)
                }
                //User - After
                if (item.mapValue.fields.userNotifications.mapValue.fields.after.mapValue.fields.isEnabled.booleanValue){
                    self.notificationHandler.setNotification(
                        message: item.mapValue.fields.userNotifications.mapValue.fields.after.mapValue.fields.message.stringValue,
                        time:  item.mapValue.fields.userNotifications.mapValue.fields.after.mapValue.fields.time.stringValue,
                        title: item.mapValue.fields.title.stringValue,
                        startOrEndTime: item.mapValue.fields.endDayAndTime.stringValue,
                        id: item.mapValue.fields.id.stringValue,
                        tag: 2)
                }
            }
        }
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    /*
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("here1")
        completionHandler()
    }*/
    
    //To show notifications when the app is in the foreground.
    //Never getting called, need to *FIX* this.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("here2")
        completionHandler([.alert, .sound, .badge])
    }
    
    func updateActiveComplication(){
        let complicationServer = CLKComplicationServer.sharedInstance()
        
        if let activeComplication = complicationServer.activeComplications {
            
            for complication in activeComplication {
                complicationServer.reloadTimeline(for: complication)
            }
            
        }
    }

}
