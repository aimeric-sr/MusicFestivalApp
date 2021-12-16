//
//  ArtistWebService.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import Foundation

protocol ArtistServiceProt {
    func getArtists() async throws -> [Artist]
    func postArtist(artist: Artist, accessToken: String) async throws -> Void
}

struct ArtistService : ArtistServiceProt {
    enum ArtistServiceError : Error {
        case failed
        case failedToDecode
        case invalidStatusCode
    }
    
    func getArtists() async throws -> [Artist] {
        let url = URL(string: APIConstants.baseURL.appending("/artists"))!
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
                  throw ArtistServiceError.invalidStatusCode
              }
        let artists = try JSONDecoder().decode([Artist].self, from: data)
        return artists
    }
    
    func postArtist(artist: Artist, accessToken: String) async throws -> Void {
        let url = URL(string: APIConstants.baseURL.appending("/artists"))!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)",forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(artist)
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 201 else {
                  throw ArtistServiceError.invalidStatusCode
              }
    }
}
