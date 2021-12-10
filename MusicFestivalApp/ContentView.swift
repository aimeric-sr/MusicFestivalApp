//
//  ContentView.swift
//  MusicFestivalApp
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var loginVM = LoginViewModel()
    
    var body: some View {
        VStack{
            Form{
                HStack{
                    Spacer()
                    Image(systemName: loginVM.isAuthenticated ? "lock.fill" : "lock.open")
                }
                TextField("Username", text: $loginVM.username)
                TextField("Password", text: $loginVM.password)
                HStack{
                    Spacer()
                    Button("login"){
                        loginVM.login()
                    }.padding()
                    Button("sign out"){
                        
                    }.padding()
                    Spacer()
                }
            }
            HStack{
                Button("Get Accounts"){
                    
                }
                .padding()
                .background(.blue)
                .cornerRadius(10)
                .foregroundColor(.white)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
