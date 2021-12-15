//
//  ArtistCellView.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import SwiftUI

struct ArtistCellView: View {
    var artist: ArtistViewModel
    var body: some View {
        HStack{
            Text("\(artist.name)")
                .padding()
                .fixedSize()
            VStack{
                Text("\(artist.nationality)")
                    .padding([.bottom, .top])
                Text("\(artist.musicStyles)")
                    .padding(.bottom)
            }
        }
    }
}

struct ArtistCellView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistCellView(artist: ArtistViewModel(artist: Artist(id:UUID(uuidString:  "35564e6b-e9f3-4810-aa2e-f118c33cb1c1")!, name: "Orelsan", nationality: "Français", music_styles: "Rap"))).previewLayout(.sizeThatFits)
            
    }
}
