//
//  ExtensionDelegate.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/6/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import WatchKit
import UserNotifications

import FirebaseCore
import FirebaseMessaging

class ExtensionDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    private let notificationHandler = NotificationHandler()
    
    func applicationDidFinishLaunching() {
        //let _ = FirebaseServices.shared
        
        FirebaseApp.configure()
        let center = UNUserNotificationCenter.current()
        
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("User granted permission. Registering for remote notifications now.")
                WKExtension.shared().registerForRemoteNotifications()
            }
            else {
                print("Permission not granted")
            }
        }
        Messaging.messaging().delegate = self
    }
    
    /// MessagingDelegate
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("Token:" + fcmToken)
    }
    
    func applicationDidBecomeActive() {
        let _ = FirebaseGoogleService.shared
        
        //model.updateDataModel {
          //  print("Updating done..")
        //}
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
      /// Swizzling should be disabled in Messaging for watchOS, set APNS token manually.
        print("Registering done. Send token to FCM now.")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
        /*
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
        }*/
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
