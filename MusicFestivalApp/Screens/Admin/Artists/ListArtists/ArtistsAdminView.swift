import SwiftUI

struct ArtistsAdminView: View {
    @EnvironmentObject var userInfo: UserSensitiveData
    @StateObject private var artistVM = ArtistListAdminVM(service: ArtistService(),authService: AuthService(), userSensitiveData: UserSensitiveData(secureStore: SecureStore()))
    
    var body: some View {
        ZStack {
            VStack {
                List(artistVM.artists, id:\.id){ artist in
                    ArtistCellAdminView(
                        isShowingModifyArtist: $artistVM.isShowingModifyArtist,
                        isShowingDeleteArtist: $artistVM.isShowingDeleteArtist,
                        artist: artist)
                }.task {
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
