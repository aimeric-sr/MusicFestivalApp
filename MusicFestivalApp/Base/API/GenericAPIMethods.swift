//
//  GenericAPIMethods.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 17/12/2021.
//

import Foundation

enum GenericServiceError : Error {
    case noResponse
    case unauthorizedError
    case internalServerError
    case unknowStatusCodeError(statusCode: Int)
}

struct GenericAPIMethods {
    static func fetchAll<T : Codable>(jwtToken jwt: String, url: URL, statusCode: Int) async throws -> [T] {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(jwt)",forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        print("response value : \n\n")
        print(response)
        guard let response = response as? HTTPURLResponse else {
            throw GenericServiceError.noResponse
        }
        
        switch response.statusCode {
        case statusCode:
            return try JSONDecoder().decode([T].self, from: data)
        case 401:
            throw GenericServiceError.unauthorizedError
        case 500:
            throw GenericServiceError.internalServerError
        default:
            throw GenericServiceError.unknowStatusCodeError(statusCode: response.statusCode)
        }
    }
}

