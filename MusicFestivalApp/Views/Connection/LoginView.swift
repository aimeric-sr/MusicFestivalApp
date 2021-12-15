//
//  ContentView.swift
//  MusicFestivalApp
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginVM = LoginViewModel(service: AuthService())
    
    var body: some View {
        VStack(){
            ZStack{
                Form{
                    Section(header: Text("Se connecter")){
                        TextField("Username", text: $loginVM.username)
                    }.padding(10)
                    Section{
                        TextField("Password", text: $loginVM.password)
                    }.padding(10)
                }
                
                HStack(spacing: 60){
                    Button("login"){
                        Task{
                            await loginVM.login()
                        }
                    }.frame(width: 100, height: 40)
                        .background(.blue)
                        .cornerRadius(10)
                        .buttonStyle(.plain)
                    Button("sign out"){
                        loginVM.signOut()
                    }.frame(width: 100, height: 40)
                        .background(.blue)
                        .cornerRadius(10)
                        .buttonStyle(.plain)
                }.frame(maxWidth: .infinity)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.light)
    }
}
