//
//  DetailedGoals.swift
//  PC-Watch WatchKit Extension
//
//  Created by admin on 6/13/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation
import Combine
import UIKit
import SwiftUI

struct Step{
    var title:String
    var status:Bool
}

class StepsModel: ObservableObject{
    @Published var steps: [Step] = [
        Step(title: "Step 1", status: false),
        Step(title: "Step 2", status: false),
        Step(title: "Step 3", status: false),
        Step(title: "Step 4", status: false)
    ]
    
    @Published var instructions: [Instruction] = [
        Instruction(img: Image("bureau"), done: false),
        Instruction(img: Image("shelf"), done: false)
    ]
    
    @Published var rowColor: Color = Color.gray
    
    @Published var completed = 0 {
        willSet {
            print("Old color: \(rowColor)")
        }
        didSet {
            //print("New value: \(completed)")
            //print("hello..")
            if completed == 1 && completed < 2 {
                rowColor = Color.yellow.opacity(0.5)
            }
            else if completed >= 2 {
                rowColor = Color.green.opacity(0.5)
            }
            else {
                rowColor = Color.gray
            }
            print("New color: \(rowColor)")
        }
    }
}

struct Instruction {
    var img: Image
    var done: Bool
}
    /*
    func getColor(compl: Int) -> Color {
        print("hello..")
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
 */
