import Foundation
import SwiftUI

protocol AddArtistViewModelProtocol : ObservableObject {
    func postArtist() async
}

@MainActor
final class AddArtistViewModel : AddArtistViewModelProtocol {
    
    @Published var name: String = ""
    @Published var nationality: String = ""
    @Published var music_styles: String = ""

    @Published var alertItem : AlertItem?
    

    private let service: ArtistServiceProtocol
    private let authService: AuthServiceProtocol
    private let keychain: KeyChainManager
    
    init(service: ArtistServiceProtocol,authService: AuthServiceProtocol, keychain: KeyChainManager){
        self.service = service
        self.authService = authService
        self.keychain = keychain
    }
    
    func postArtist() async {
        do {
            let accessToken = keychain.accessToken
            guard let accessToken = accessToken else {
                alertItem = APIAlertContext.invalidToken
                return
            }
            try await service.postArtist(name: self.name, nationality: self.nationality, music_styles: self.music_styles, accessToken: accessToken)
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
                return await postArtist()
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
