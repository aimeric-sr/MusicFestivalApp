//
//  ContentView.swift
//  MusicFestivalApp
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var loginVM = LoginViewModel()
    @StateObject private var artistListVM = ArtistListViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    HStack{
                        Spacer()
                        Image(systemName: loginVM.isAuthenticated ? "lock.fill" : "lock.open")
                    }
                    TextField("Username", text: $loginVM.username)
                    TextField("Password", text: $loginVM.password)
                    
                }
                HStack{
                    Button("login"){
                        loginVM.login()
                    }.padding()
                    Button("sign out"){
                        print("sign out pressed")
                        loginVM.signOut()
                    }.padding()
                }
                VStack{
                    Spacer()
                    if(loginVM.isAuthenticated){
                        List(artistListVM.artists, id:\.id){ artist in
                            HStack{
                                Text("\(artist.id)")
                                Text("\(artist.name)")
                                Text("\(artist.nationality)")
                                Text("\(artist.musicStyles)")
                            }
                        }
                    }
                    Spacer()
                    Button("Get Artists"){
                        artistListVM.getAllArtists()
                    }
                    .padding()
                    .background(.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }
            }.navigationTitle("Login")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
