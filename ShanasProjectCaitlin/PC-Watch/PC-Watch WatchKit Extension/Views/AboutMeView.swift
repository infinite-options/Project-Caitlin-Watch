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
//    let profilePhotoData = UserDefaults(suiteName: "manifestSuite")?.data(forKey: "userPhoto")
//    let profilePhoto =
    
    var body: some View {
        GeometryReader { geo in
        ScrollView([.vertical]){
            Spacer()
            VStack{
                Image(systemName: "person.circle")
                //Image(uiImage: UIImage(data: self.profilePhotoData!)!)
                    .font(.system(size:44))
                    .foregroundColor(.yellow)
                Text("\(self.fullName!)")
                
                NavigationLink(destination: SignInView()){
                    Text("Change User")
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
