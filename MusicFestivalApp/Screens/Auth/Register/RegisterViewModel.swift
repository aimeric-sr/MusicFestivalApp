import Foundation

protocol RegisterViewModelProt: ObservableObject {
    func register() async
}

@MainActor
final class RegisterViewModel : RegisterViewModelProt {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var isRegistered: Bool = false
    var confirmPassword: String = ""
    @Published var alertItem: AlertItem?
    
    private let service: AuthServiceProtocol
    private let keychain: KeyChainManager
    
    init(service: AuthServiceProtocol, keychain: KeyChainManager){
        self.service = service
        self.keychain = keychain
    }
    
    func register() async {
        do {
            try await service.register(username: self.username, password: self.password, email: self.email)
            self.isRegistered = true 
        } catch APIError.invalidURL {
            alertItem = APIAlertContext.invalidURL
        } catch APIError.invalidDataSend {
            alertItem = APIAlertContext.invalidDataSend
        } catch APIError.invalidResponse {
            alertItem = APIAlertContext.invalidResponse
        }  catch APIError.internalServerError {
            alertItem = APIAlertContext.internalServerError
        }  catch APIError.unknowStatusCodeError {
            alertItem = APIAlertContext.unknowStatusCodeError
        } catch {
            alertItem = APIAlertContext.unknowError
        }
    }
    
    //validation data form
    func passwordsMatch() -> Bool {
        return self.password == self.confirmPassword
    }
    
    var isRegisterComplete: Bool {
        if (!passwordsMatch() || !password.isValidPassword || !email.isValidEmail || !username.isValidUsername){
            return false
        }
        return true
    }
    
    //prompt string
    var usernamePrompt: String {
        if username.isValidUsername{
            return ""
        }else {
            return "Username must be at least 8 characters"
        }
    }
    
    var passwordPrompt: String {
        if password.isValidPassword{
            return ""
        }else {
            return "Minimum 8 characters, at least 1 uppercase letter and 1 lowercase letter and 1 number:"
        }
    }
    
    var confirmPwPrompt: String {
        if passwordsMatch(){
            return ""
        }else {
            return "Password fiels do not match"
        }
    }
    
    var emailPrompt: String {
        if email.isValidEmail{
            return ""
        }else {
            return "Enter a valid email address"
        }
    }
}
