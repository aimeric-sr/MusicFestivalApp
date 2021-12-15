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
            NavigationView{
                switch artistVM.state {
                case .success:
                    List(artistVM.artists, id:\.id){ artist in
                        ArtistCellView(artist: artist)
                    }.navigationTitle("Artists")
                        .refreshable {
                            await artistVM.getArtists()
                            print("refresh api")
                        }
                case .loading :
                    ProgressView()
                default:
                    EmptyView()
                }
            }
            .task{
                await artistVM.getArtists()
            }
            Button("refresh"){
                refreshArtists()
            }
        }
    }
    
    func refreshArtists() {
      Task {
        await artistVM.getArtists()
        print("refresh")
      }
    }
    
}

struct ArtistsView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistsView()
    }
}
