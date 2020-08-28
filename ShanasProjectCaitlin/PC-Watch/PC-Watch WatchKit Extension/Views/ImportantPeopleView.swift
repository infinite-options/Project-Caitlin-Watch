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
    private var rows = FirebaseGoogleService.shared.peopleRow

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
            } else if (self.model.importantPeople == nil || rows == nil){
                VStack {
                    Text("You do not have any important people yet.")
                        .fontWeight(.bold)
                        .font(.system(size: 20, design: .rounded))
                    Spacer()
                }
            } else {
                ScrollView([.vertical]) {
                    ForEach(rows!) { row in
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
