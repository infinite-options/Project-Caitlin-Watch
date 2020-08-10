//
//  LaunchScreenView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 8/9/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct LaunchScreenView: View {

    @ObservedObject var viewPick = ViewController.shared
    @ObservedObject var User = UserDay.shared

    var body: some View {
        GeometryReader { geo in
            VStack{
                Image("App Icon")
                    .resizable()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    .frame(width: 40, height: 40)
                    .padding([.top, .bottom], 10)
                
                Text("Manifest MySpace")
                    .fontWeight(.bold)
                    .font(.system(size: 19, design: .rounded))

                Spacer()
                
                NavigationLink(destination: SignInView()){
                    Text("Sign In")
                        .foregroundColor(Color.yellow)
                }

            }.navigationBarTitle("Welcome")
            .frame(maxHeight: geo.size.height)
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
