//
//  DoneButton.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 8/31/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct DoneButton<Cont: View>: View {
    
    let action: () -> Void
    let content: Cont
    
    init(action: @escaping () -> Void, @ViewBuilder content: () -> Cont) {
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(action: action) {
            content
                .padding(2)
        }
    }
}
