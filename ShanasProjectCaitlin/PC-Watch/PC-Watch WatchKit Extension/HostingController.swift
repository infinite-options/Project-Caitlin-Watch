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

class HostingController: WKHostingController<RootView> {
    override var body: RootView {
        return RootView()
    }
}

class SecondHostingController: WKHostingController<HomeView> {
    override var body: HomeView {
        return HomeView()
    }
}

/*
class HostingController: WKHostingController<Test> {
    override var body: Test {
        return Test()
    }
}
*/
