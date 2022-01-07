import Foundation

enum KeyChainManagerError: Error {
    case KeyChainCreateError
    case KeyChainDeleteError
}

protocol KeyChainManagerProtocol: ObservableObject {
    
    func setAccessToken(accessTokenInput: String) throws -> Void
    func setRefreshToken(refreshTokenInput: String) throws -> Void
    func deleteAccessToken() throws -> Void
    func deleteRefreshToken() throws -> Void
    
    func checkFirstRun() -> Void
    func swipeKeyChainData() throws -> Void
    func isBasic() -> Bool
    func isAdmin() -> Bool
    
}

final class KeyChainManager: KeyChainManagerProtocol {
    private let secureStore: SecureStoreProtocol

    init(secureStore: SecureStoreProtocol){
        self.secureStore = secureStore
    }
    
    func setAccessToken(accessTokenInput: String) throws -> Void {
        do {
            try secureStore.set(entry: accessTokenInput, forKey: "accessToken")
        } catch {
            throw KeyChainManagerError.KeyChainCreateError
        }
    }
    
    func setRefreshToken(refreshTokenInput: String) throws -> Void {
        do {
            try secureStore.set(entry: refreshTokenInput, forKey: "refreshToken")
        } catch {
            throw KeyChainManagerError.KeyChainCreateError
        }
    }
    
    var accessToken: String? {
        do {
            return try secureStore.entry(forKey: "accessToken")
        } catch {
            return nil
        }
    }
    
    var refreshToken: String?  {
        do {
            return try secureStore.entry(forKey: "refreshToken")
        } catch {
            return nil
        }
    }
    
    func deleteAccessToken() throws -> Void {
        do {
            try secureStore.removeEntry(forKey: "accessToken")
        } catch {
            throw KeyChainManagerError.KeyChainDeleteError
        }
    }
    
    func deleteRefreshToken() throws -> Void {
        do {
            try secureStore.removeEntry(forKey: "refreshToken")
        } catch {
            throw KeyChainManagerError.KeyChainDeleteError
        }
    }
    
    func checkFirstRun() -> Void {
        do {
            let userDefaults = UserDefaults.standard
            if !userDefaults.bool(forKey: "hasRunBefore") {
                do {
                    try swipeKeyChainData()
                } catch {
                    throw KeyChainManagerError.KeyChainDeleteError
                }
                userDefaults.set(true, forKey: "hasRunBefore")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func swipeKeyChainData() throws -> Void {
        do {
            try deleteAccessToken()
            try deleteRefreshToken()
        } catch {
            throw KeyChainManagerError.KeyChainDeleteError
        }
    }
    
    func isBasic() -> Bool {
        do {
            if (refreshToken != nil){
                let payload = try JWTReader.decode(jwtToken: self.refreshToken ?? "")
                let role = payload["role"]!
                return String(describing: role) == "BASIC"
            }
            return false
        } catch {
            return false
        }
    }
    
    func isAdmin() -> Bool {
        do {
            if (refreshToken != nil){
                let payload = try JWTReader.decode(jwtToken: self.refreshToken ?? "")
                let role = payload["role"]!
                return String(describing: role) == "ADMIN"
            }
            return false
        } catch {
            return false
        }
    }
    
}
