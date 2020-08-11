//
//  SwiftUIView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 8/4/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI
import UIKit

struct SignInView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewPick = ViewController.shared
    @State private var emailId = ""
    @ObservedObject var User = UserDay.shared
    
    var body: some View {

        GeometryReader { geo in
            ScrollView([.vertical]){
                VStack{
                    Text("Enter Email")
                        .fontWeight(.bold)
                        .font(.system(size: 19, design: .rounded))
                        .padding(.bottom, 25)
                    
                    Spacer()
                    
                    TextField("Email", text: self.$emailId)
                        .textContentType(.username)
                        .multilineTextAlignment(.center)
                    
                    if self.User.isUserSignedIn == .invalidEmail {
                        Text("Incorrect Email")
                            .foregroundColor(Color.red)
                    }
                    
                    Button(action: {
                        self.User.loadingUser = true
                        print(self.emailId)
                        
                        self.User.getUserFromEmail(email: self.emailId) { (status) in
                            if status == 200 {
                                print("Signed in. User ID: \(self.User.User)")
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            else {
                                DispatchQueue.main.async {
                                    self.User.isUserSignedIn = .invalidEmail
                                }
                            }
                        }
                    }){
                        Text("Done")
                    }.sheet(isPresented: self.$User.loadingUser) {
                        LoadingView()
                    }
                        
                    .disabled(self.emailId.isEmpty)
                    .accentColor(self.emailId.isEmpty ? Color.red : Color.green)
                }.edgesIgnoringSafeArea([.leading, .trailing, .bottom])
                .navigationBarTitle("Sign In")
                .navigationBarBackButtonHidden(false)
            }
        }
    }
}

#if DEBUG
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
#endif

//                    Image("App Icon")
//                        .resizable()
//                        .clipShape(Circle())
//                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
//                        .frame(width: 40, height: 40)

//struct LaunchScreenView: View {
//
//    @ObservedObject var viewPick = ViewController.shared
//    @ObservedObject var User = UserDay.shared
//
//    var body: some View {
//
//                ScrollView([.vertical]){
//                    VStack{
//                        Spacer()
//
//                        Text("Manifest MySpace")
//                            .fontWeight(.bold)
//                            .font(.system(size: 19, design: .rounded))
//                        
//                        Spacer()
//
//                        if self.User.isUserSignedIn == .signedIn {
//                            Text("Current User")
//                            Text("Placeholder")
//                            Button(action: {
//                                self.viewPick.showView = .showHome
//                            }){
//                                Text("Continue")
//                            }
//                        }
//                        Text("Or")
//                        Button(action: {
//                            self.viewPick.showView = .showSignin
//                        }){
//                            Text("Change User")
//                        }
//
//                    }.edgesIgnoringSafeArea([.leading, .trailing, .bottom])
//                }
//    }
//}

//struct RootView: View {
//    var body: some View {
//        ContentView().environmentObject(ViewController())
//    }
//}

//struct RootView: View {
//
//    @ObservedObject var viewPick = ViewController.shared
//
//    var body: some View {
//        
//        return Group {
//            if self.viewPick.showView == .showLaunch {
//                LaunchScreenView()
//            }
//            if self.viewPick.showView == .showSignin {
//                SignInView()
//            }
//            else if self.viewPick.showView == .showLoading {
//                LoadingView()
//            }
//            else if self.viewPick.showView == .showHome {
//                HomeView()
//            }
//        }
//    }
//}

//struct SignInView: View {
//
//    @ObservedObject var viewPick = ViewController.shared
//    @State private var emailId = ""
//    @ObservedObject var User = UserDay.shared
//
//    var body: some View {
//
//        GeometryReader { geo in
//            ScrollView([.vertical]){
//                VStack{
//                    Text("Enter Email")
//                        .fontWeight(.bold)
//                        .font(.system(size: 19, design: .rounded))
//                        .padding(.bottom, 25)
//
//                    Spacer()
//
//                    TextField("Email", text: self.$emailId)
//                        .textContentType(.username)
//                        .multilineTextAlignment(.center)
//
//                    if self.User.isUserSignedIn == .invalidEmail {
//                        Text("Incorrect Email")
//                            .foregroundColor(Color.red)
//                    }
//
//                    Button(action: {
//                        self.viewPick.showView = .showLoading
//                        print(self.emailId)
//
//                        self.User.getUserFromEmail(email: self.emailId) { (status) in
//                            if status == 200 {
//                                DispatchQueue.main.async {
//                                    self.User.isUserSignedIn = .signedIn
//                                }
//                            }
//                            else {
//                                DispatchQueue.main.async {
//                                    self.User.isUserSignedIn = .invalidEmail
//                                    self.viewPick.showView = .showSignin
//                                }
//                            }
//                        }
//                    }){
//                        Text("Done")
//                    }
//                    .disabled(self.emailId.isEmpty)
//                    .accentColor(self.emailId.isEmpty ? Color.red : Color.green)
//                }.edgesIgnoringSafeArea([.leading, .trailing, .bottom])
//                .navigationBarTitle("Sign In")
//                .navigationBarBackButtonHidden(false)
//            }
//        }
//    }
//}

