//
//  CreateAccountView.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 16/12/2021.
//

import SwiftUI

struct CreateAccountView: View {
    @StateObject private var registerVM = RegisterViewModel(service: AuthService())
    
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    Section(header: Text("USERNAME")){
                        TextField("Username", text: $registerVM.username)
                    }
                    Section(header: Text("PASSWORD")){
                        SecureField("Password", text: $registerVM.password)
                        SecureField("Confirm Password", text: $registerVM.confirmPassword)
                    }
                    Section(header: Text("EMAIL")){
                        TextField("Username", text: $registerVM.email)
                    }
                }.textInputAutocapitalization(.never)
                
                Button(action : {
                    Task{
                        await registerVM.register()
                    }
                }){
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 60)
                        .overlay(
                            Text("Register")
                                .foregroundColor(.white)
                        )
                }.padding()
                
                Group{
                    //redirection views
                }
            }.navigationTitle("Create Account")
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
