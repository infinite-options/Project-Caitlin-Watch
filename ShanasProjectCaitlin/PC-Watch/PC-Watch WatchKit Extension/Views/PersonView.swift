//
//  PersonView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 8/16/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct PersonView: View {
    var person: ImportantPerson
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(self.person.fields.name.stringValue)
                        .font(.system(size: 20, design: .rounded))
                    Text(self.person.fields.relationship.stringValue)
                        .fontWeight(.light)
                        .font(.system(size: 15))
                }
                Spacer()
                if self.person.fields.havePic.booleanValue == false {
                    Image(systemName: "person.circle")
                        .font(.system(size:50))
                        .foregroundColor(.yellow)
                }
                else {
                    AsyncImage(
                        url: URL(string: self.person.fields.pic!.stringValue)!,
                        placeholder: Image(systemName: "person.circle"))
                }
            }
            Spacer()
            if self.person.fields.phoneNumber?.stringValue != "" {
                Image(systemName: "phone.circle")
                    .font(.system(size:50))
                    .foregroundColor(.green)
                    .onTapGesture {
                        let number = "tel:" + self.person.fields.phoneNumber!.stringValue
                        if let telURL = URL(string: number) {
                            let wkExtension = WKExtension.shared()
                            wkExtension.openSystemURL(telURL)
                        }
                    }
            }
        }.navigationBarTitle(self.person.fields.name.stringValue)
    }
}

//struct PersonView_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonView()
//    }
//}
