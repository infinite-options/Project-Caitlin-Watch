//
//  SwiftUIView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 8/4/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI
import UIKit

struct SignInView: View {
    @State var clickedSignIn = false
    @State private var userName = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            if !clickedSignIn {
                Button(action: {
                    self.clickedSignIn = true
                }) {
                    Text("Sign In")
                        .foregroundColor(.yellow)
                }
            } else {
                TextField("User Name", text: self.$userName)
                    .textContentType(.username)
                    .multilineTextAlignment(.center)
                SecureField("Password", text: self.$password)
                    .textContentType(.password)
                    .multilineTextAlignment(.center)
                Button("Done") {
                }.disabled(self.userName.isEmpty || self.password.isEmpty)
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
