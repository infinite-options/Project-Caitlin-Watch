//
//  PersistentView.swift
//  PC-Watch WatchKit Extension
//
//  Created by admin on 6/12/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

class DayDate {
    var dueDate = Date()
    let weekday = Calendar.current.component(.weekday, from: Date())
    var day = ["","SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    let taskDateFormat: DateFormatter = {
              let formatter = DateFormatter()
              formatter.dateStyle = .medium
              formatter.locale = Locale(identifier: "en_US")
              formatter.setLocalizedDateFormatFromTemplate("d")
              return formatter
      }()
    
    let timeLeft: DateFormatter = {
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        //formatter2.dateFormat = "dd MM yyyy'T'HH:mm:ss'Z'"
        return formatter2
    }()
    
    func getTimeLeft(givenDate:String) -> TimeInterval{
        let fromDate = timeLeft.date(from: timeLeft.string(from: Date()))!
        let toDate = timeLeft.date(from: givenDate)!
        print(toDate)
        print(fromDate)
        var delta = toDate.timeIntervalSince(fromDate)
        print(delta)
        if delta < 0.0{
            return 0.0
        }
        else{
            delta = delta/60
            return delta
        }
    }
}

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
                            //self.viewRouter.currentPage = "goal"
                        print("in help")
                    }
                Spacer()
            }
        }.padding(0)
    }
    
}

struct PersistentView_Previews: PreviewProvider {
    static var previews: some View {
        PersistentView(goal: false, event: true, routine: true, help: true)
    }
}
