import Foundation

protocol LoginViewModelProt: ObservableObject {
    func login() async
    //func signOut() async
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
    
    init(service: AuthServiceProtocol){
        self.service = service
    }
    
    func login() async {
        do {
            let loginResponse = try await service.login(username: username, password: password)
            let secureStore = SecureStore()
            let payload = try JsonWebToken.decode(jwtToken: loginResponse.accessToken!)
            let role = payload["role"]!
            self.roleName = String(describing: role)
            try secureStore.set(entry: loginResponse.accessToken!, forKey: "accessToken")
            try secureStore.set(entry: loginResponse.refreshToken!, forKey: "refreshToken")
            self.isAuthenticated = true
        } catch APIError.invalidURL {
            alertItem = AlertContext.invalidURL
        } catch APIError.invalidDataSend {
            alertItem = AlertContext.invalidDataSend
        } catch APIError.invalidResponse {
            alertItem = AlertContext.invalidResponse
        } catch APIError.invalidData {
            alertItem = AlertContext.invalidData
        } catch APIError.invalidUsername {
            alertItem = AlertContext.invalidUsername
        } catch APIError.invalidPassword {
            alertItem = AlertContext.invalidPassword
        } catch APIError.invalidToken {
            alertItem = AlertContext.invalidToken
        } catch APIError.internalServerError {
            alertItem = AlertContext.internalServerError
        } catch APIError.unknowStatusCodeError {
            alertItem = AlertContext.unknowStatusCodeError
        } catch {
            alertItem = AlertContext.unknowError
        }
    }
    
//    func signOut(){
//        let secureStore = SecureStore()
//        do{
//            try secureStore.removeEntry(forKey: "accessToken")
//            try secureStore.removeEntry(forKey: "refreshToken")
//        }catch{
//            self.hasError = true
//        }
//        self.isAuthenticated = false
//    }
    
}
