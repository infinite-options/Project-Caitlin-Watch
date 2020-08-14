//
//  ImportantPeopleView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 8/12/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct PeopleView: View {
    var item: ImportantPerson
    
    var body: some View {
         VStack(alignment: .leading) {
            Text(item.fields.name.stringValue)
        }
    }
}

struct ImportantPeopleView: View {
    @ObservedObject private var model = FirebaseGoogleService.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(Array((self.model.importantPeople?.filter{ isImportantPerson(item: $0) == true }.enumerated())!), id: \.offset) { index, item in
                    VStack(alignment: .leading) {
                        PeopleView(item: self.model.importantPeople![index])
                    }.listRowPlatterColor(Color.gray)
                }
            }.listStyle(CarouselListStyle())
                .navigationBarTitle("Important People")
        }.padding(0)
    }
    
    private func isImportantPerson(item: ImportantPerson) -> Bool{
        if item.fields.important.booleanValue == true {
            return true
        } else {
            return false
        }
    }
}

struct ImportantPeopleView_Previews: PreviewProvider {
    static var previews: some View {
        ImportantPeopleView()
    }
}
