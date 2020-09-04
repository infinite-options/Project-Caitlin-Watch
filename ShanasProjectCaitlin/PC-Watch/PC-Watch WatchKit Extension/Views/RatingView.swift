//
//  RatingView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 8/26/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct RatingView: View {
    
    var notificationController: RatingNotificationController
    
    var body: some View {
        VStack {
            Text("How are you")
                .fontWeight(.bold)
                .font(.system(size: 19, design: .rounded))
            Text("feeling?")
                .fontWeight(.bold)
                .font(.system(size: 19, design: .rounded))
//            HStack {
//                Image(systemName: "hand.thumbsdown.fill")
//                    .font(.system(size:50))
//                    .foregroundColor(Color.red.opacity(0.9))
//                Spacer()
//                Image(systemName: "hand.thumbsup.fill")
//                    .font(.system(size:50))
//                    .foregroundColor(Color.green.opacity(0.9))
//            }.padding(30)
            HStack {
                Image("frown")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        print("sad")
                        self.notificationController.performDismissAction()
                    }
                Spacer()
                Image("meh")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        print("ok")
                        self.notificationController.performDismissAction()
                    }
                Spacer()
                Image("smile")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        print("happy")
                        self.notificationController.performDismissAction()
                    }
            }.padding(10)
        }
    }
}

//struct RatingView_Previews: PreviewProvider {
//    static var previews: some View {
//        RatingView()
//    }
//}
