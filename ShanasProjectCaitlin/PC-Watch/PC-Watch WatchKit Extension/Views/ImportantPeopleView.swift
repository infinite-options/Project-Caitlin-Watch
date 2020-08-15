//
//  ImportantPeopleView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 8/12/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct ImportantPeopleView: View {
    @ObservedObject private var model = FirebaseGoogleService.shared
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        .navigationBarTitle("Important People")
    }
}

struct ImportantPeopleView_Previews: PreviewProvider {
    static var previews: some View {
        ImportantPeopleView()
    }
}
