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
        ScrollView([.vertical]){
            Spacer()
            VStack{
//                Image(systemName: "person.circle")
                if self.User.UserPhoto == nil {
                    Image(systemName: "person.circle")
                        .font(.system(size:50))
                        .foregroundColor(.yellow)
                }
                else{
                    Image(uiImage: self.User.UserPhoto ?? UIImage())
                        .resizable()
                        .frame(width: 65, height: 65)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.yellow, lineWidth: 1))
                }
                Text("\(self.fullName!)")
                    .fontWeight(.bold)
                    .font(.system(size: 19, design: .rounded))
                
                NavigationLink(destination: SignInView()){
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
