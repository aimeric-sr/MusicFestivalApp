import Foundation

protocol ArtistListAdminVMProt : ObservableObject {
    func getArtists() async
    func postArtist(artist : Artist) async
}

//to update data on the main thread which is the UI thread
@MainActor
final class ArtistListAdminVM : ArtistListAdminVMProt {
    
    @Published private(set) var artists : [ArtistViewModel] = []
    @Published var alertItem : AlertItem?
    @Published var isLoading : Bool = false
    @Published var isShowingAddArtist : Bool = false
    @Published var isShowingModifyArtist : Bool = false
    @Published var isShowingDeleteArtist : Bool = false
    private let service: ArtistServiceProtocol
    private let authService: AuthServiceProtocol
    private let userSensitiveData: UserSensitiveData
    
    init(service: ArtistServiceProtocol,authService: AuthServiceProtocol, userSensitiveData: UserSensitiveData){
        self.service = service
        self.authService = authService
        self.userSensitiveData = userSensitiveData
    }
    
    func getArtists() async{
        self.isLoading = true
        do {
            
            let accessToken = userSensitiveData.getAccessToken()
            guard let accessToken = accessToken else {
                alertItem = AlertContext.invalidToken
                return
            }
            self.artists = try await service.getArtists(accessToken: accessToken).map(ArtistViewModel.init)
            self.isLoading = false
        } catch {
            if  let APIError = error as? APIError{
                switch APIError {
                case .invalidURL:
                    alertItem = AlertContext.invalidURL
                case .invalidResponse:
                    alertItem = AlertContext.invalidResponse
                case .invalidData:
                    alertItem = AlertContext.invalidData
                case .invalidToken:
                    do {
                        let refreshToken = userSensitiveData.getRefreshToken()
                        guard let refreshToken = refreshToken else {
                            alertItem = AlertContext.invalidToken
                            return
                        }
                        let accessTokenResponse = try await authService.getAccessToken(refreshToken: refreshToken)
                        userSensitiveData.setAccessToken(accessTokenInput: accessTokenResponse.accessToken)
                        return await getArtists()
                    } catch {
                        alertItem = AlertContext.invalidToken
                    }
                case .internalServerError:
                    alertItem = AlertContext.internalServerError
                case .unknowStatusCodeError(statusCode: _):
                    alertItem = AlertContext.unknowStatusCodeError
                default:
                    break
                }
            } else {
                //generic error
                alertItem = AlertContext.unknowError
            }
            self.isLoading = false
        }
    }
    
    func postArtist(artist : Artist) async {
        do {
            let secureStore = SecureStore()
            let accessToken = try secureStore.entry(forKey: "accessToken")!
            try await service.postArtist(artist: artist,jwt: accessToken)
        }catch{
            print("test")
        }
    }
}


