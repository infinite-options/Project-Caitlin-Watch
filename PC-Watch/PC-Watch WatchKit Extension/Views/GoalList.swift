//
//  GoalList.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/8/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct GoalList: View {

    @State var data = [Value]()
    
    var body: some View {
        NavigationLink(destination:
            VStack(alignment: .leading) {
                    Text("Goals")
                        .bold()
                    List (data, id: \.mapValue.fields.id.stringValue) { item in
                        if !item.mapValue.fields.isPersistent.booleanValue
                        && item.mapValue.fields.isAvailable.booleanValue {
                        Text(item.mapValue.fields.title.stringValue)
                    }
                }
            }
            .onAppear { FirebaseServices().getFirebaseData() { (data) in
                self.data = data
                
                }
            }) {
            Text("Goals")
                .frame(height: 50, alignment: .center)
        }
    }
}

struct GoalList_Previews: PreviewProvider {
    static var previews: some View {
        GoalList()
    }
}
