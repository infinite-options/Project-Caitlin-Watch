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
        List{
                RoutineList()
                GoalList()
                EventsList()
            }
        }
    }

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        }
    }
