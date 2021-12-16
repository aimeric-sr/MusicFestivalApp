//
//  WebService.swift
//  MusicFestivalApp
//
//  Created by Aimeric Sorin on 10/12/2021.
//

enum AuthenticationError : Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

enum NetworkError : Error {
    case invalidURL
    case noData
    case decodingError
}

struct LoginRequestBody : Codable {
    let username: String
    let password: String
}

struct RegisterRequestBody : Codable {
    let username: String
    let password: String
    let email: String
}

struct LoginResponse : Codable {
    let accessToken: String?
    let refreshToken: String?
}

import Foundation

protocol AuthServiceProt {
    func login(username: String, password: String) async throws -> LoginResponse
    func register(username: String, password: String, email: String) async throws -> Void
}

final class AuthService : AuthServiceProt{
    enum AuthServiceError : Error {
        case failed
        case failedToDecode
        case invalidStatusCode
    }
    
    func login(username: String, password: String) async throws -> LoginResponse {
        let url = URL(string: APIConstants.baseURL.appending("/auth/login"))!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let loginBody = LoginRequestBody(username: username, password: password)
        request.httpBody = try? JSONEncoder().encode(loginBody)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
                  throw AuthServiceError.invalidStatusCode
              }
        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
        return loginResponse
    }
    
    func register(username: String, password: String, email: String) async throws -> Void {
        let url = URL(string: APIConstants.baseURL.appending("/auth/register"))!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let registerBody = RegisterRequestBody(username: username, password: password, email: email)
        request.httpBody = try? JSONEncoder().encode(registerBody)
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 201 else {
                  throw AuthServiceError.invalidStatusCode
              }
        print(response.statusCode)
        return
    }
    
}
