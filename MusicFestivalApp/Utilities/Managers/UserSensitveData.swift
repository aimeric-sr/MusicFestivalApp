//
//  RefreshToken.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 28/12/2021.
//

import Foundation

enum UserInfoError: Error {
    case KeyChainCreateError
    case KeyChainDeleteError
}

protocol UserSensitiveDataProtocol: ObservableObject {
    func swipeKeyChainData() throws -> Void
    func isBasic() -> Bool
    func isAdmin() -> Bool
    func setAccessToken(accessTokenInput: String) -> Void
    func setRefreshToken(refreshTokenInput: String) -> Void
    func getAccessToken() -> String?
    func getRefreshToken() -> String?
    func deleteAccessToken() throws -> Void
    func deleteRefreshToken() throws -> Void
}

final class UserSensitiveData: UserSensitiveDataProtocol {
    let secureStore: SecureStoreProt

    init(secureStore: SecureStoreProt){
        self.secureStore = SecureStore()
    }
    
    var accessToken: String? {
        do {
            return try secureStore.entry(forKey: "accessToken")
        } catch {
            return nil
        }
    }
    
    var refreshToken: String? {
        do {
            return try secureStore.entry(forKey: "refreshToken")
        } catch {
            return nil
        }
    }
    
    func checkFirstRun() throws -> Void {
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: "hasRunBefore") {
            do {
                try swipeKeyChainData()
            } catch {
                throw UserInfoError.KeyChainDeleteError
            }
            userDefaults.set(true, forKey: "hasRunBefore")
        }
    }
    
    func swipeKeyChainData() throws -> Void {
        do {
            try deleteAccessToken()
            try deleteRefreshToken()
        } catch {
            throw UserInfoError.KeyChainDeleteError
        }
    }
    
    func isBasic() -> Bool {
        do {
            if (refreshToken != nil){
                let payload = try JsonWebToken.decode(jwtToken: self.refreshToken ?? "")
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
                let payload = try JsonWebToken.decode(jwtToken: self.refreshToken ?? "")
                let role = payload["role"]!
                return String(describing: role) == "ADMIN"
            }
            return false
        } catch {
            return false
        }
    }
    
    func setAccessToken(accessTokenInput: String) -> Void {
        do {
            try secureStore.set(entry: accessTokenInput, forKey: "accessToken")
        } catch {
            return
        }
    }
    
    func setRefreshToken(refreshTokenInput: String) -> Void {
        do {
            try secureStore.set(entry: refreshTokenInput, forKey: "refreshToken")
        } catch {
            return
        }
    }
    
    func getAccessToken() -> String? {
        do {
            return try secureStore.entry(forKey: "accessToken")
        } catch {
            return nil
        }
    }
    
    func getRefreshToken() -> String? {
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
            throw UserInfoError.KeyChainDeleteError
        }
    }
    
    func deleteRefreshToken() throws -> Void {
        do {
            try secureStore.removeEntry(forKey: "refreshToken")
        } catch {
            throw UserInfoError.KeyChainDeleteError
        }
    }
}
