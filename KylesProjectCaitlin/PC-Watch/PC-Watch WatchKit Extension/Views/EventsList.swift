//
//  EventsList.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/8/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct EventsList: View {
    
    var body: some View {
        NavigationLink(destination: Text("Events Page")) {
            Text("Events")
            .frame(height: 50, alignment: .center)
        }
    }
}

struct EventsList_Previews: PreviewProvider {
    static var previews: some View {
        EventsList()
    }
}
