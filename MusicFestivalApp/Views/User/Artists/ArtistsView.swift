//
//  ArtistsView.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import SwiftUI

struct ArtistsView: View {
    
    @StateObject private var artistVM = ArtistListViewModel(service: ArtistService())
    
    var body: some View {
        VStack {
            Button("ajout artiste"){
                Task{
                    await artistVM.postArtist()
                }
            }
            NavigationView{
                switch artistVM.state {
                case .success:
                    List(artistVM.artists, id:\.id){ artist in
                        ArtistCellView(artist: artist)
                    }
                    .navigationTitle("Artists")
                    .refreshable{
                        Task{
                            await artistVM.getArtists()
                        }
                    }
                case .loading :
                    LoadingView(text: "Fetching Artists")
                default:
                    EmptyView()
                }
            }
            .task{
                await artistVM.getArtists()
            }
            .alert("Error",
                   isPresented:  $artistVM.hasError,
                   presenting: artistVM.state) {detail in
                Button("Retry"){
                    Task {
                        await artistVM.getArtists()
                    }
                }
            } message : {detail in
                if case let .failed(error) = detail {
                    Text(error)
                }
            }
        }
    }
}

struct ArtistsView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistsView()
    }
}
