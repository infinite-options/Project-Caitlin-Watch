//
//  ImportantPeopleView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 8/12/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct PeopleRow: Identifiable {
    let id = UUID()
    var cells = [Cell]()

    init(cells: [Cell]) {
        self.cells = cells
    }
}

extension PeopleRow {
    static func populate(people: [ImportantPerson]) -> [PeopleRow] {
        var rows = [PeopleRow]()
        var i = 0
        var col = 0
        while i < people.count {
            let dif = people.count - 1 - i
            if dif > 2 {
                if (col % 2 == 0) {
                    rows.append(PeopleRow(cells: [Cell(person: people[i]), Cell(person: people[i+1]), Cell(person: people[i+2])]))
                    i+=3
                    col+=1
                } else {
                    rows.append(PeopleRow(cells: [Cell(person: people[i]), Cell(person: people[i+1]), Cell(person: people[i+2]), Cell(person: people[i+3])]))
                    i+=4
                    col+=1
                }
            } else if dif == 2 {
                rows.append(PeopleRow(cells: [Cell(person: people[i]), Cell(person: people[i+1]), Cell(person: people[i+2])]))
                i+=3
            } else if dif == 1 {
                rows.append(PeopleRow(cells: [Cell(person: people[i]), Cell(person: people[i+1])]))
                i+=2
            } else {
                rows.append(PeopleRow(cells: [Cell(person: people[i])]))
                i+=1
            }
        }
        return rows
    }
}

struct Cell: Identifiable {
    let id = UUID()
    var person: ImportantPerson

    init(person: ImportantPerson) {
        self.person = person
    }
}

struct PeopleView: View {
    var person: ImportantPerson

    var body: some View {
        NavigationLink(destination: PersonView(person: person)) {
            if self.person.fields.havePic.booleanValue == false {
                Image(systemName: "person.circle")
                    .font(.system(size:40))
                    .foregroundColor(.yellow)
            }
            else {
                AsyncSmallImage(
                    url: URL(string: self.person.fields.pic!.stringValue)!,
                    placeholder: Image(systemName: "person.circle"))
            }
        }.buttonStyle(PlainButtonStyle())
    }
}

struct ImportantPeopleView: View {
    @ObservedObject private var model = FirebaseGoogleService.shared
    @ObservedObject private var user = UserDay.shared

    let rows = PeopleRow.populate(people: (FirebaseGoogleService.shared.importantPeople!))

    var body: some View {
        VStack(alignment: .center) {
            if(self.user.isUserSignedIn != .signedIn || self.user.isUserSignedIn == .signedOut) {
                VStack {
                    Text("You're not signed in yet.")
                        .fontWeight(.bold)
                        .font(.system(size: 20, design: .rounded))
                    Spacer()
                    NavigationLink(destination: SignInView()) {
                        Text("Sign In")
                            .foregroundColor(Color.yellow)
                    }
                }
            } else if (self.model.importantPeople == nil){
                VStack {
                    Text("You do not have any important people yet.")
                        .fontWeight(.bold)
                        .font(.system(size: 20, design: .rounded))
                    Spacer()
                }
            } else {
                ScrollView([.vertical]) {
                    ForEach(rows) { row in
                        HStack(alignment: .center) {
                            ForEach(row.cells) { cell in
                                PeopleView(person: cell.person)
                            }
                        }
                    }
                }
            }
        }.navigationBarTitle("Important People")
    }

//    private func isImportantPerson(item: ImportantPerson) -> Bool{
//        if item.fields.important.booleanValue == true {
//            return true
//        } else {
//            return false
//        }
//    }
}

struct ImportantPeopleView_Previews: PreviewProvider {
    static var previews: some View {
        ImportantPeopleView()
    }
}

//old edits below

//import SwiftUI
//
//struct PeopleView: View {
//    var person: ImportantPerson
//
//    var body: some View {
//         VStack(alignment: .leading) {
//            Text(person.fields.name.stringValue)
//                .font(.system(size: 20, design: .rounded))
//            Text("Relationship: " + person.fields.relationship.stringValue)
//                .fontWeight(.light)
//                .font(.system(size: 15))
//        }
//    }
//}
//
//struct ImportantPeopleView: View {
//    @ObservedObject private var model = FirebaseGoogleService.shared
//    @ObservedObject private var user = UserDay.shared
//
//    var body: some View {
//        VStack {
//            if(self.user.isUserSignedIn != .signedIn){
//                VStack(alignment: .center) {
//                    Text("You're not signed in yet.")
//                        .fontWeight(.bold)
//                        .font(.system(size: 20, design: .rounded))
//                    Spacer()
//                }
//            } else if (self.model.importantPeople == nil){
//                VStack(alignment: .center) {
//                    Text("You do not have any important people yet.")
//                        .fontWeight(.bold)
//                        .font(.system(size: 20, design: .rounded))
//                    Spacer()
//                }
//            } else {
//                VStack(alignment: .leading) {
//                    List {
//                        ForEach(Array((self.model.importantPeople?/*.filter{ isImportantPerson(item: $0) == true }*/.enumerated())!), id: \.offset) { index, person in
//                            NavigationLink(destination: PersonView(person: person)){
//                                VStack(alignment: .leading) {
//                                    PeopleView(person: person)
//                                }
//                            }.listRowPlatterColor(Color.blue)
//                        }
//                    }.listStyle(CarouselListStyle())
//                }.padding(0)
//            }
//        }.navigationBarTitle("Important People")
//    }
//
//    private func isImportantPerson(item: ImportantPerson) -> Bool{
//        if item.fields.important.booleanValue == true {
//            return true
//        } else {
//            return false
//        }
//    }
//}
//
//struct ImportantPeopleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImportantPeopleView()
//    }
//}
