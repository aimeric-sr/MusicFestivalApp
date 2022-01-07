import Foundation

protocol LoginViewModelProt: ObservableObject {
    func login() async
}

@MainActor
final class LoginViewModel : LoginViewModelProt {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var roleName: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var createAccountView: Bool = false
    @Published var alertItem: AlertItem?
    
    private let service: AuthServiceProtocol
    private let keyChain: KeyChainManager
    
    init (service: AuthServiceProtocol, keyChain: KeyChainManager){
        self.service = service
        self.keyChain = keyChain
    }
    
    func login() async {
        do {
            
            let loginResponse = try await service.login(username: username, password: password)
            guard let accessToken = loginResponse.accessToken else {
                alertItem = APIAlertContext.invalidData
                return
            }
            guard let refreshToken = loginResponse.refreshToken else {
                alertItem = APIAlertContext.invalidData
                return
            }
            let payload = try JWTReader.decode(jwtToken: accessToken)
            guard let role = payload["role"] else {
                alertItem = APIAlertContext.invalidData
                return
            }
            self.roleName = String(describing: role)
            try keyChain.setAccessToken(accessTokenInput: accessToken)
            try keyChain.setRefreshToken(refreshTokenInput: refreshToken)
            self.isAuthenticated = true
            
        } catch APIError.invalidURL {
            alertItem = APIAlertContext.invalidURL
        } catch APIError.invalidDataSend {
            alertItem = APIAlertContext.invalidDataSend
        } catch APIError.invalidResponse {
            alertItem = APIAlertContext.invalidResponse
        } catch APIError.invalidData {
            alertItem = APIAlertContext.invalidData
        } catch APIError.invalidUsername {
            alertItem = APIAlertContext.invalidUsername
        } catch APIError.invalidPassword {
            alertItem = APIAlertContext.invalidPassword
        } catch APIError.invalidToken {
            alertItem = APIAlertContext.invalidToken
        } catch APIError.internalServerError {
            alertItem = APIAlertContext.internalServerError
        } catch APIError.unknowStatusCodeError {
            alertItem = APIAlertContext.unknowStatusCodeError
        } catch {
            alertItem = APIAlertContext.unknowError
        }
    }
}
