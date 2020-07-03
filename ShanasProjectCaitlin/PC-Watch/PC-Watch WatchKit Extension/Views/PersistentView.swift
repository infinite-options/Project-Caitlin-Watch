//
//  PersistentView.swift
//  PC-Watch WatchKit Extension
//
//  Created by admin on 6/12/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct PersistentView: View {
    var goal: Bool
    var event: Bool
    var routine: Bool
    var help: Bool

    var body: some View {
        
        HStack{
            Spacer()
            if(self.goal){
                NavigationLink(destination: GoalList()){
                    Image("Goals").renderingMode(.original).resizable().frame(width:43, height:43)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                }.buttonStyle(PlainButtonStyle())
            }
            if(self.routine){
                NavigationLink(destination: RoutineList()){
                    Image("Tasks").renderingMode(.original).resizable().frame(width:43, height:43)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                }.buttonStyle(PlainButtonStyle())
                Spacer()
            }
            if(self.event){
                NavigationLink(destination: EventsList()){
                    Image("Events").resizable().frame(width:38, height:38)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                }.buttonStyle(PlainButtonStyle())
                Spacer()
            }
            if(self.help){
                Image("help").resizable().clipShape(Circle()).frame(width:38, height:38)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)).onTapGesture {
                        print("in help")
                    }
                Spacer()
            }
        }.padding(0)
    }
    
}

struct PersistentView_Previews: PreviewProvider {
    static var previews: some View {
        PersistentView(goal: true, event: true, routine: true, help: true)
    }
}
