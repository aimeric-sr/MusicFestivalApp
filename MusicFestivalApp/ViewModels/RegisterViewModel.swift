import Foundation

protocol RegisterViewModelProt: ObservableObject {
    func register() async
}

@MainActor
final class RegisterViewModel : RegisterViewModelProt {
    enum State {
        case na
        case loading
        case success
        case failed(error: Error)
    }
    
    var username: String = ""
    var confirmPassword: String = ""
    var password: String = ""
    var email: String = ""
    
    @Published private(set) var state : State = .na
    @Published var hasError : Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var isFormValid: Bool = false
    @Published var roleName: String = ""
    @Published var createAccountView: Bool = false
    
    private let service: AuthServiceProt
    
    init(service: AuthServiceProt){
        self.service = service
    }
    
    func register() async{
        self.state = .loading
        self.hasError = false
        do {
            try await service.register(username: self.username, password: self.password, email: self.email)
            self.state = .success
        }catch{
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
