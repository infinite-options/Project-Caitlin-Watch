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
    let profilePhotoData = UserDefaults(suiteName: "manifestSuite")?.data(forKey: "userPhoto")
//    let profilePhoto =
    
    var body: some View {
        GeometryReader { geo in
        ScrollView([.vertical]){
            Spacer()
            VStack{
//                Image(systemName: "person.circle")
                Image(uiImage: (UIImage(data: self.profilePhotoData!) ?? UIImage(named: "person.circle")) ?? UIImage())
                    .resizable()
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.yellow, lineWidth: 1))
                    .font(.system(size:44))
                    .foregroundColor(.yellow)
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
