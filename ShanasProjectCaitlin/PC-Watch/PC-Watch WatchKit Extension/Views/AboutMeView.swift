//
//  AboutMeView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 8/9/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct AboutMeView: View {
    
    @ObservedObject var viewPick = ViewController.shared
    @ObservedObject var User = UserDay.shared
    
    let fullName = UserDefaults(suiteName: "manifestSuite")?.string(forKey: "userName")
    
    var body: some View {
        GeometryReader { geo in
            ScrollView([.vertical]) {
                Spacer()
                VStack {
                    if self.User.UserPhoto == nil {
                        Image(systemName: "person.circle")
                            .font(.system(size:50))
                            .foregroundColor(.yellow)
                    }
                    else{
                        Image(uiImage: self.User.UserPhoto ?? UIImage())
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.yellow, lineWidth: 1))
                    }
                    Text("\(self.fullName!)")
                        .fontWeight(.bold)
                        .font(.system(size: 19, design: .rounded))
                    
                    NavigationLink(destination: SignInView()) {
                        Text("Change User")
                            .foregroundColor(Color.green)
                    }
                }
            }.navigationBarTitle("About Me")
        }
    }
}

struct AboutMeView_Previews: PreviewProvider {
    static var previews: some View {
        AboutMeView()
    }
}

// New Edits below

//import SwiftUI
//
//struct AboutMeView: View {
//    
//    @ObservedObject var viewPick = ViewController.shared
//    @ObservedObject var User = UserDay.shared
//    @ObservedObject var model = FirebaseGoogleService.shared
//    
//    let fullName = UserDefaults(suiteName: "manifestSuite")?.string(forKey: "userName")
//    
//    var body: some View {
//        GeometryReader { geo in
//            if self.User.isUserSignedIn == .signedIn {
//                ScrollView([.vertical]) {
//                    Spacer()
//                    VStack {
//                        if self.User.UserPhoto == nil {
//                            Image(systemName: "person.circle")
//                                .font(.system(size:50))
//                                .foregroundColor(.yellow)
//                        }
//                        else{
//                            Image(uiImage: self.User.UserPhoto ?? UIImage())
//                                .resizable()
//                                .frame(width: 80, height: 80)
//                                .clipShape(Circle())
//                                .overlay(Circle().stroke(Color.yellow, lineWidth: 1))
//                        }
//                        if self.fullName != nil {
//                            Text("\(self.fullName!)")
//                                .fontWeight(.bold)
//                                .font(.system(size: 19, design: .rounded))
//                        }
//                        NavigationLink(destination: SignInView()) {
//                            Text("Switch Accounts")
//                                .foregroundColor(Color.green)
//                        }
//                        NavigationLink(destination: SignInView()) {
//                            Text("Sign Out")
//                                .foregroundColor(Color.yellow)
//                                .onTapGesture {
//                                    self.User.isUserSignedIn = .signedOut
//                                    self.User.User = ""
//                                    self.User.manifestSuite?.set(self.User.User, forKey: self.User.manifestUserIdKey)
//                                }
//                        }
//                    }
//                }.navigationBarTitle("About Me")
//            } else {
//                VStack {
//                    Text("You're not signed in yet.")
//                        .fontWeight(.bold)
//                        .font(.system(size: 20, design: .rounded))
//                    Spacer()
//                    Spacer()
//                    NavigationLink(destination: SignInView()) {
//                        Text("Sign In")
//                            .foregroundColor(Color.yellow)
//                    }
//                }.navigationBarTitle("About Me")
//            }
//        }
//    }
//}
//
//struct AboutMeView_Previews: PreviewProvider {
//    static var previews: some View {
//        AboutMeView()
//    }
//}
//
