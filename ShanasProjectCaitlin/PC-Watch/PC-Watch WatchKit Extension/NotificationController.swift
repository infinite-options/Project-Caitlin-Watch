//
//  NotificationController.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/6/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import WatchKit
import SwiftUI
import UserNotifications

class NotificationController: WKUserNotificationHostingController<NotificationView> {

    override var body: NotificationView {
        return NotificationView()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        print("huh?")
        super.willActivate()
        /*let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("User granted permission.")
            }
            else {
                print("Permission not granted")
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Hi I am a notification!"
        content.body = "Look at me!"
        
        let date = Date().addingTimeInterval(5)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            print(error)
        }*/
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func didReceive(_ notification: UNNotification) {
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
    }
}

class RatingNotificationController: WKUserNotificationHostingController<RatingView> {

    override var body: RatingView {
        return RatingView(notificationController: self)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        print("activated")
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        print("didDeactivate")
        super.didDeactivate()
    }

    override func didReceive(_ notification: UNNotification) {
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        print("didDeactivate")
    }

//    @IBAction func smileButton() {
//        print("You are happy")
//        performDismissAction()
//    }
//
//    @IBAction func mehButton() {
//        print("You are ok")
//        performDismissAction()
//    }
//
//    @IBAction func frownButton() {
//        print("You are sad")
//        performDismissAction()
//    }
}

