//
//  RoutineList.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/8/20.
//  Updated by Shana Duchin in 4/11/20 and onward
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct RoutineList: View {
    
    @State var data = [Value]()
    
    var body: some View {
        NavigationLink(destination:
           
            List {
                ForEach(data.filter{$0.mapValue.fields.isPersistent.booleanValue}, id: \.mapValue.fields.id.stringValue) { item in
                    
                    VStack(alignment: .leading) {
                        //Text("Routines")
                        //.bold()
                    if item.mapValue.fields.isAvailable.booleanValue {
                        
                        if item.mapValue.fields.photo.stringValue != "" {
                            HStack {
                                AsyncImage(
                                    url: URL(string: item.mapValue.fields.photo.stringValue)!,
                                    placeholder: Image("blacksquare")
                                    ).aspectRatio(contentMode: .fit)
                                Text(item.mapValue.fields.title.stringValue)
                                                       
                            }
                            
                        }
//                            else {
//                                HStack {
//                                    Image("blacksquare")
//                                    .resizable()
//                                    .frame(width: 30, height: 30)
//                                    .clipShape(Circle())
//                                    .overlay(Circle().stroke(Color.white, lineWidth: 0.5))
//                                    .shadow(radius: 10)
//                                    .padding(EdgeInsets(top: 10, leading: -1, bottom: 10, trailing: 1.5))
//                                    Text(item.mapValue.fields.title.stringValue)
//                                }
//
//                            }
//
                        }
                    }

                }
            }
            .onAppear { FirebaseServices().getFirebaseData() { (data) in
                self.data = data
                print(self.data)
                
                }
            }) {
            Text("Routines")
                .frame(height: 50, alignment: .center)
        }
    }
}

struct RoutineList_Previews: PreviewProvider {
    static var previews: some View {
        RoutineList()
    }
}
