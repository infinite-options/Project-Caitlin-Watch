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

class NotificationController: WKUserNotificationHostingController<RatingView> {

    override var body: RatingView {
        return RatingView(notificationController: self)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        print("nottification will activate")
        super.willActivate()
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
