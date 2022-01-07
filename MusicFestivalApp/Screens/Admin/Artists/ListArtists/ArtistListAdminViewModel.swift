import Foundation

protocol ArtistListAdminVMProt : ObservableObject {
    func getArtists() async
    func deleteArtist() async
}

//to update data on the main thread which is the UI thread
@MainActor
final class ArtistListAdminVM : ArtistListAdminVMProt {
    
    @Published var artists : [ArtistViewModel] = []
    @Published var selectedArtist : ArtistViewModel?
    @Published var alertItem : AlertItem?
    @Published var isLoading : Bool = false
    @Published var isShowingAddArtist : Bool = false
    @Published var isShowingModifyArtist : Bool = false
    @Published var isShowingDeleteArtist : Bool = false
    private let service: ArtistServiceProtocol
    private let authService: AuthServiceProtocol
    private let keychain: KeyChainManager
    
    init(service: ArtistServiceProtocol,authService: AuthServiceProtocol, keychain: KeyChainManager){
        self.service = service
        self.authService = authService
        self.keychain = keychain
    }
    
    func getArtists() async {
        self.isLoading = true
        do {
            let accessToken = keychain.accessToken
            guard let accessToken = accessToken else {
                alertItem = APIAlertContext.invalidToken
                return
            }
            self.artists = try await service.getArtists(accessToken: accessToken).map(ArtistViewModel.init)
            self.isLoading = false
        } catch APIError.invalidURL {
            alertItem = APIAlertContext.invalidURL
            self.isLoading = false
        } catch APIError.invalidResponse {
            alertItem = APIAlertContext.invalidResponse
            self.isLoading = false
        } catch APIError.invalidData {
            alertItem = APIAlertContext.invalidData
            self.isLoading = false
        } catch APIError.invalidToken {
            do {
                let refreshToken = keychain.refreshToken
                guard let refreshToken = refreshToken else {
                    alertItem = APIAlertContext.invalidToken
                    return
                }
                let accessTokenResponse = try await authService.getAccessToken(refreshToken: refreshToken)
                try keychain.setAccessToken(accessTokenInput: accessTokenResponse.accessToken)
                return await getArtists()
            } catch {
                alertItem = APIAlertContext.invalidToken
                self.isLoading = false
            }
        } catch APIError.internalServerError {
            alertItem = APIAlertContext.internalServerError
            self.isLoading = false
        } catch APIError.unknowStatusCodeError {
            alertItem = APIAlertContext.unknowStatusCodeError
            self.isLoading = false
        } catch {
            alertItem = APIAlertContext.unknowError
            self.isLoading = false
        }
    }
    
    func deleteArtist() async {
        guard let selectedArtist = selectedArtist else {
            alertItem = UIAlertContext.deleteArtistError
            return
        }
        do {
            let accessToken = keychain.accessToken
            guard let accessToken = accessToken else {
                alertItem = APIAlertContext.invalidToken
                return
            }
            try await service.deleteArtist(id: selectedArtist.id, accessToken: accessToken)
        } catch APIError.invalidURL {
            alertItem = APIAlertContext.invalidURL
        } catch APIError.invalidResponse {
            alertItem = APIAlertContext.invalidResponse
        } catch APIError.invalidToken {
            do {
                let refreshToken = keychain.refreshToken
                guard let refreshToken = refreshToken else {
                    alertItem = APIAlertContext.invalidToken
                    return
                }
                let accessTokenResponse = try await authService.getAccessToken(refreshToken: refreshToken)
                try keychain.setAccessToken(accessTokenInput: accessTokenResponse.accessToken)
                return await deleteArtist()
            } catch {
                alertItem = APIAlertContext.invalidToken
            }
        } catch APIError.internalServerError {
            alertItem = APIAlertContext.internalServerError
        } catch APIError.unknowStatusCodeError {
            alertItem = APIAlertContext.unknowStatusCodeError
        } catch {
            alertItem = APIAlertContext.unknowError
        }
    }
}

