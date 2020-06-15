//
//  GoalList.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/8/20.
//  Updated by Shana Duchin 
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct DetailedGoalView: View {
    @ObservedObject var model: StepsModel
    @ObservedObject var InstructModel = InstructionsStep()
    /*
    let colorbinding: Binding(
        get: { return Color.gray },
        set: {
            return Color{
                if compl == 1 && compl < 2 {
                    return Color.yellow.opacity(0.5)
                }
                else if compl >= 2 {
                    return Color.green.opacity(0.5)
                }
                else {
                    return Color.gray
                }
            }
        }
    )*/
    
    var body: some View{
        List{
            
            ForEach(model.steps.indices, id: \.self){ id in
                NavigationLink(destination: InstructionView(InstructModel: self.InstructModel,
                                step: self.model.steps[id].title)) {
                    VStack{
                        Text(self.model.steps[id].title)
                        .font(.system(.headline, design: .rounded))
                    }.listRowPlatterColor(self.InstructModel.rowColor)
                }
            }
        }
    }
}


struct InstructionView: View{
    @ObservedObject var InstructModel: InstructionsStep
    
    var step: String
    //@State var instructStatus = [false, false]
    //@State var showOverlay: Bool = false
    var body: some View{
        //Text("\(step)")
        VStack{
        /*List{
            ForEach(InstructModel.instructions.indices, id: \.self){ id in
                Button(action: {print("Images")}){
                    self.InstructModel.instructions[id].img.renderingMode(.original)
                }.buttonStyle(PlainButtonStyle())
            }
        }*/
            HStack{
                Button(action: {
                    self.InstructModel.instructions[0].done = true
                    self.InstructModel.completed += 1
                    print("\(self.InstructModel.rowColor)")
                }){
                    if self.InstructModel.instructions[0].done == false {
                        self.InstructModel.instructions[0].img.renderingMode(.original)
                    }
                    else if self.InstructModel.instructions[0].done {
                        self.InstructModel.instructions[0].img.renderingMode(.original)
                        .overlay(Image("check")).opacity(0.4)
                    }
                }.buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    self.InstructModel.instructions[1].done = true
                    self.InstructModel.completed += 1
                }){
                    if self.InstructModel.instructions[1].done == false {
                        self.InstructModel.instructions[1].img.renderingMode(.original)
                    }
                    else if self.InstructModel.instructions[1].done {
                        self.InstructModel.instructions[1].img.renderingMode(.original)
                        .overlay(Image("check")).opacity(0.4)
                    }
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
}


struct GoalList: View {
    
    @State var data = [Value]()
    //@EnvironmentObject var InstructModel: InstructionsStep
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    Text("\(DayDateObj.day[DayDateObj.weekday]), \(DayDateObj.dueDate, formatter: DayDateObj.taskDateFormat)")
                        .font(.system(size: 15.0, design: .rounded))
                }.frame(maxWidth: geo.size.width, alignment: .leading)
                    
                Text("Current Goals").foregroundColor(Color.red)
                    .font(.system(.headline, design: .rounded))
                Spacer()
                List {
                    ForEach(self.data.filter{!($0.mapValue.fields.isPersistent.booleanValue)}, id: \.mapValue.fields.id.stringValue) { item in
                        VStack(alignment: .leading) {
                            if item.mapValue.fields.isAvailable.booleanValue {
                                if item.mapValue.fields.photo.stringValue != "" {
                                    NavigationLink(destination: DetailedGoalView(model: StepsModel())){
                                        HStack {
                                            AsyncImage(
                                                url: URL(string: item.mapValue.fields.photo.stringValue)!,
                                                    placeholder: Image("blacksquare")
                                                        ).aspectRatio(contentMode: .fit)
                                                    Text(item.mapValue.fields.title.stringValue)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }.onAppear {
                    FirebaseServices().getFirebaseData() {
                        (data) in self.data = data
                    }
                }
                PersistentView(goal: false, event: true, routine: true, help: true)
            }.edgesIgnoringSafeArea(.bottom).padding(0)
        }
    }
}

struct GoalList_Previews: PreviewProvider {
    static var previews: some View {
        GoalList()
    }
}
