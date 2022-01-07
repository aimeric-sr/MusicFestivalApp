//
//  AddArtistView.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 05/01/2022.
//

import SwiftUI

struct AddArtistView: View {
    @ObservedObject var artistVM : AddArtistViewModel
    @Binding var isShowingAddArtist : Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    isShowingAddArtist.toggle()
                } label: {
                    XDismissButton()
                }
            }
            Form {
                Section(header: Text("Artist Name")){
                    TextField("Artist Name", text: $artistVM.name){}
                }
                Section(header: Text("Artist Nationality")){
                    TextField("Artist Name", text: $artistVM.nationality){}
                }
                Section(header: Text("Artist Music Styles")){
                    TextField("Artist Name", text: $artistVM.music_styles){}
                }
            }
            
            Button(action : {
                Task{
                    await artistVM.postArtist()
                }
                isShowingAddArtist.toggle()
            }, label: {
                Text("Add New Artist")
                    .frame(maxWidth: .infinity)
            }).padding()
            .buttonStyle(.bordered)
            .tint(.accentColor)
            .controlSize(.large)
        }
        .alert(item: $artistVM.alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        })
    }
}

struct AddArtistView_Previews: PreviewProvider {
    static var previews: some View {
        AddArtistView(artistVM: AddArtistViewModel(
            service: ArtistService(),
            authService: AuthService(),
            keychain: KeyChainManager(secureStore: SecureStore())
        ),isShowingAddArtist: .constant(false))
    }
}
