//
//  HomeView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/6/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct TaskCompleteImage: View {
    //TODO: Add some logic to TaskComplete so open circle is not done
    //and checkmark is done
    var body : some View {
        Image("check")
        .resizable()
        .frame(width: 20, height: 20)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 0.5))
        .shadow(radius: 10)
            .padding(EdgeInsets(top: 10, leading: 1, bottom: 10, trailing: 1.5))
    }
}

struct TaskIncompleteImage: View {
    var body : some View {
        Image("")
        .resizable()
        .frame(width: 20, height: 20)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 0.5))
        .shadow(radius: 10)
            .padding(EdgeInsets(top: 10, leading: 1, bottom: 10, trailing: 1.5))
    }
}

struct GoalView: View {
    var itemID: String?
    var name: String?
    var time: String?
    
    var body: some View {
        NavigationLink(destination: TasksView(itemID: itemID)){
            VStack {
                HStack {
                    HStack {
                        Text(name!).fontWeight(.bold).font(.system(size: 20))
                        Spacer()
                        TaskCompleteImage()
                    }
                }
                HStack {
                    Text(time!).fontWeight(.light).font(.system(size: 15))
                    Spacer()
                }
            }.frame(height: 90)
        }
    }
}

struct RoutineView: View {
    var itemID: String?
    var name: String?
    var time: String?
    
    var body: some View {
        NavigationLink(destination: TasksView(itemID: itemID)){
            VStack {
                HStack {
                    HStack {
                        Text(name!).fontWeight(.bold).font(.system(size: 20))
                        Spacer()
                        TaskCompleteImage()
                    }
                }
                HStack {
                    Text(time!).fontWeight(.light).font(.system(size: 15))
                    Spacer()
                }
            }.frame(height: 90).listRowPlatterColor(Color.gray)
        }
    }
}

struct EventView: View {
    var itemID: String?
    var name: String?
    var time: String?
    
    var body: some View {
        NavigationLink(destination: TasksView(itemID: itemID)){
            VStack {
                HStack {
                    HStack {
                        Text(name!).fontWeight(.bold).font(.system(size: 20))
                        Spacer()
                        TaskCompleteImage()
                    }
                }
                HStack {
                    Text(time!).fontWeight(.light).font(.system(size: 15))
                    Spacer()
                }
            }.frame(height: 90).listRowPlatterColor(Color.yellow.opacity(0.75))
        }
    }
}

struct HomeView: View {
    @ObservedObject private var model = FirebaseServices.shared
    
    let timeLeft: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        formatter.timeZone = .current
        print(formatter.timeZone!)
        return formatter
    }()

    let formatter: DateFormatter = {
        let formatter1 = DateFormatter()
        formatter1.timeZone = .current
        formatter1.dateFormat = "h:mm a"
        return formatter1
    }()
    
    var body: some View {

        GeometryReader { geo in
            if (self.model.data == nil){
                VStack(alignment: .leading) {
                    Text("You dont have any Goals to show!")
                    Spacer()
                }
            }
            else {
                VStack(alignment: .leading) {
                    List {
                        ForEach(self.model.data!.filter{!($0.mapValue.fields.isPersistent.booleanValue)}, id: \.mapValue.fields.id.stringValue) { item in
                            VStack {
                                if item.mapValue.fields.isAvailable.booleanValue {
                                    GoalView(itemID:item.mapValue.fields.id.stringValue, name: item.mapValue.fields.title.stringValue, time: self.formatter.string(from: self.timeLeft.date(from: item.mapValue.fields.startDayAndTime.stringValue)!)  + " - " + self.formatter.string(from: self.timeLeft.date(from: item.mapValue.fields.endDayAndTime.stringValue)!))
                                }
                            }
                        }
                    }.listStyle(CarouselListStyle()).navigationBarTitle("My Day")
                }.edgesIgnoringSafeArea(.bottom).padding(0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
