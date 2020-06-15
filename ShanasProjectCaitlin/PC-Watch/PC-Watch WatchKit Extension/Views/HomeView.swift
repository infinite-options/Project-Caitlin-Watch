//
//  HomeView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/6/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @State var data = [Value]()
    
    var body: some View {
        /*List{
            NavigationLink(destination: RoutineList()){Text("Routines").frame(height: 50, alignment: .center)}
                
            NavigationLink(destination: GoalList()){Text("Goals").frame(height: 50, alignment: .center)}
            
            NavigationLink(destination: EventsList()){Text("Events").frame(height: 50, alignment: .center)}
                
            }*/
        VStack{
            Spacer()
            PersistentView(goal: true, event: true, routine: true, help: false)
        }.edgesIgnoringSafeArea(.bottom).padding(0)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        }
    }
