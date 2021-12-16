import Foundation

protocol ArtistListViewModelProt : ObservableObject {
    func getArtists() async
    func postArtist() async
}

//to update data on the main thread which is the UI thread
@MainActor
final class ArtistListViewModel : ArtistListViewModelProt {
    enum State {
        case na
        case loading
        case success
        case failed(error: Error)
    }
    
    @Published private(set) var state : State = .na
    @Published var hasError : Bool = false
    @Published private(set) var artists : [ArtistViewModel] = []
    private let service: ArtistServiceProt
    
    init(service: ArtistServiceProt){
        self.service = service
    }
    
    func getArtists() async{
        self.state = .loading
        self.hasError = false
        do {
            self.artists = try await service.getArtists().map(ArtistViewModel.init)
            self.state = .success
        }catch{
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    
    func postArtist() async{
        self.state = .loading
        self.hasError = false
        do {
            try await service.postArtist(artist: Artist(id: nil, name: "jfean", nationality: "francfeais", music_styles: "tecfhno"), accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjMyMDkwYzAwLTg1MDktNDFkYy1iNWFiLWQ4NTA3OGU3ZDMwNSIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTYzOTU3NjQxMSwiZXhwIjoxNjM5NTc3MzExfQ.MGz7GQEeDtHalJX02T7UEEqm2-WDoKOJt6d4xv0hLHE")
            self.state = .success
        }catch{
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}

struct ArtistViewModel {
    let artist : Artist
    
    init(artist: Artist){
        self.artist = artist
    }
    
    var id: UUID {
        return self.artist.id!
    }
    var name: String {
        return self.artist.name
    }
    var nationality: String {
        return self.artist.nationality
    }
    var musicStyles: String {
        return self.artist.music_styles
    }
}
