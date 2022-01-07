import SwiftUI

struct ArtistsAdminView: View {
    @EnvironmentObject var userInfo: KeyChainManager
    @StateObject private var artistVM = ArtistListAdminVM(
        service: ArtistService(),
        authService: AuthService(),
        keychain: KeyChainManager(secureStore: SecureStore()))
    
    var body: some View {
        ZStack {
            VStack {
                Button {
                    artistVM.isShowingAddArtist.toggle()
                } label: {
                    Text("Add artist")
                }

                List(){
                    ForEach(artistVM.artists, id:\.id){ artist in
                        ArtistCellAdminView(
                            selectedArtist: $artistVM.selectedArtist,
                            isShowingModifyArtist: $artistVM.isShowingModifyArtist,
                            isShowingDeleteArtist: $artistVM.isShowingDeleteArtist,
                            artist: artist)
                    }
                }
                .task {
                    await artistVM.getArtists()
                }
                .refreshable{
                    Task{
                        await artistVM.getArtists()
                    }
                }
            }
            .navigationTitle("Artists")

            if artistVM.isLoading { LoadingView(text: "Fetching Artists") }
        }
        .sheet(isPresented: $artistVM.isShowingAddArtist, content: {
            AddArtistView(artistVM: AddArtistViewModel(
                service: ArtistService(),
                authService: AuthService(),
                keychain: KeyChainManager(secureStore: SecureStore())), isShowingAddArtist: $artistVM.isShowingAddArtist)
        })
        .confirmationDialog("Are you sure ?", isPresented: $artistVM.isShowingDeleteArtist, titleVisibility: .visible){
            Button("Delete", role: .destructive){
                Task {
                    await artistVM.deleteArtist()
                    await artistVM.getArtists()
                }
            }
        }
        .alert(item: $artistVM.alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        })
    }
}


struct ArtistsAdminView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistsAdminView()
    }
}
