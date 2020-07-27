//
//  AttendeesView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 7/24/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI


struct AtendeesView: View {
    var event: Event?
    
    var body: some View {
        VStack {
            ScrollView([.vertical]) {
//                if event!.atendees == nil {
//                    VStack(alignment: .center) {
//                        Text("No other atendees.")
//                    }
//                }
//                ForEach(Range(NSRange(1, 10)), id: \.offset) { index, item in
                    HStack {
                        Image(systemName: "person.circle")
                            .font(.system(size:44))
                            .foregroundColor(.yellow)
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Emma Allegrucci")
                                .font(.system(size: 18, design: .rounded))
//                            Text("emmallegrucci@gmail.com")
//                                .font(.system(size: 12, design: .rounded))
                        }
                    }

                Divider()
//                }
            }
        }.navigationBarTitle("Atendees")
    }
}
