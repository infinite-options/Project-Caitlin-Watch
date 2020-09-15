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

class SecondHostingController: WKHostingController<AboutMeView> {
    override var body: AboutMeView {
        return AboutMeView()
    }
}

class HostingController: WKHostingController<RootView> {
    override var body: RootView {
        return RootView()
    }
}

class ThirdHostingController: WKHostingController<ImportantPeopleView> {
    override var body: ImportantPeopleView {
        return ImportantPeopleView()
    }
}
