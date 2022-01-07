import SwiftUI

struct ArtistCellAdminView: View {
    @Binding var selectedArtist : ArtistViewModel?
    @Binding var isShowingModifyArtist : Bool
    @Binding var isShowingDeleteArtist : Bool
    var artist: ArtistViewModel
    var body: some View {
        VStack{
            Text("\(artist.name)")
                .bold()
                .font(.title3)
                .padding(.bottom)
                .multilineTextAlignment(.center)
            HStack{
                Label("\(artist.nationality)", systemImage: "flag.fill")
                Spacer()
                Label("\(artist.musicStyles)", systemImage: "music.mic")
            }
        }
        .padding()
        .onTapGesture {
           
        }
        .swipeActions(edge: .leading,allowsFullSwipe: true){
            Button(action:{
                    isShowingModifyArtist.toggle()
                },
                   label: {
                Image(systemName: "pencil")
            }).tint(.green)
        }.swipeActions(edge: .trailing, allowsFullSwipe: true){
            Button(action:{
                    selectedArtist = self.artist
                    isShowingDeleteArtist.toggle()
                },
                   label: {
                Image(systemName: "trash.fill")
            }).tint(.red)
        }
    }
}

struct ArtistCellAdminView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistCellAdminView(selectedArtist: .constant(nil), isShowingModifyArtist: .constant(false), isShowingDeleteArtist: .constant(false), artist: ArtistViewModel(artist: Artist.dummyData[0])).previewLayout(.sizeThatFits)
    }
}
