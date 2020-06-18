//
//  HostingController.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/6/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

import UserNotifications

class HostingController: WKHostingController<HomeView> {
    override var body: HomeView {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                
            }
            
            // Enable or disable features based on the authorization.
        }
        
        return HomeView()
    }
}
