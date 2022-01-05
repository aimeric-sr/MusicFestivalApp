import Foundation

struct ArtistViewModel {
    let id: UUID
    let name: String
    let nationality: String
    let musicStyles: String
    
    init(artist: Artist){
        self.id = artist.id
        self.name = artist.name
        self.nationality = artist.nationality
        self.musicStyles = artist.music_styles
    }
}
