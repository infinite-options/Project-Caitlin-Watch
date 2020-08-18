//
//  ImportantPeopleView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 8/12/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct PeopleView: View {
    var person: ImportantPerson
    
    var body: some View {
         VStack(alignment: .leading) {
            Text(person.fields.name.stringValue)
                .font(.system(size: 20, design: .rounded))
            Text("Relationship: " + person.fields.relationship.stringValue)
                .fontWeight(.light)
                .font(.system(size: 15))
        }
    }
}

struct ImportantPeopleView: View {
    @ObservedObject private var model = FirebaseGoogleService.shared
    @ObservedObject private var user = UserDay.shared
    
    var body: some View {
        VStack {
            if(self.user.isUserSignedIn != .signedIn){
                VStack(alignment: .center) {
                    Text("You're not signed in yet.")
                        .fontWeight(.bold)
                        .font(.system(size: 20, design: .rounded))
                    Spacer()
                }
            } else if (self.model.importantPeople == nil){
                VStack(alignment: .center) {
                    Text("You do not have any important people yet.")
                        .fontWeight(.bold)
                        .font(.system(size: 20, design: .rounded))
                    Spacer()
                }
            } else {
                VStack(alignment: .leading) {
                    List {
                        ForEach(Array((self.model.importantPeople?/*.filter{ isImportantPerson(item: $0) == true }*/.enumerated())!), id: \.offset) { index, person in
                            NavigationLink(destination: PersonView(person: person)){
                                VStack(alignment: .leading) {
                                    PeopleView(person: person)
                                }
                            }.listRowPlatterColor(Color.blue)
                        }
                    }.listStyle(CarouselListStyle())
                }.padding(0)
            }
        }.navigationBarTitle("Important People")
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
