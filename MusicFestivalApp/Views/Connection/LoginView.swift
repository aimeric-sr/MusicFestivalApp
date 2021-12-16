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
        NavigationView{
            VStack(){
                ZStack{
                    Form{
                        Section(header: Text("Se connecter")){
                            TextField("Username", text: $loginVM.username)
                        }.padding(10)
                        Section{
                            TextField("Password", text: $loginVM.password)
                        }.padding(10)
                    }.textInputAutocapitalization(.never)
                    
                    HStack(spacing: 60){
                        Button("login"){
                            Task{
                                await loginVM.login()
                            }
                        }.frame(width: 150, height: 40)
                            .background(.blue)
                            .cornerRadius(10)
                            .buttonStyle(.plain)
                        Button("create account"){
                            //go to create account view
                        }.frame(width: 150, height: 40)
                            .background(.blue)
                            .cornerRadius(10)
                            .buttonStyle(.plain)
                    }.frame(maxWidth: .infinity)
                    
                }
                
                if(loginVM.roleName == "ADMIN" && loginVM.isAuthenticated){
                    NavigationLink(destination: AdminHomeView().navigationBarBackButtonHidden(true), isActive: $loginVM.isAuthenticated) { EmptyView() }
                    
                }
                if(loginVM.roleName == "BASIC" && loginVM.isAuthenticated){
                    NavigationLink(destination: UserHomeView().navigationBarBackButtonHidden(true), isActive: $loginVM.isAuthenticated) { EmptyView() }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
                .preferredColorScheme(.light)
        }
    }
}
