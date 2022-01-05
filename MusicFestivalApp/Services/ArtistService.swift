import Foundation

protocol ArtistServiceProtocol {
    func getArtists(accessToken: String) async throws -> [Artist]
    func postArtist(artist: Artist, jwt: String) async throws -> Void
}

struct ArtistService : ArtistServiceProtocol {
    func getArtists(accessToken: String) async throws -> [Artist] {
        guard let url = URL(string: APIConstants.baseURL.appending("/artists")) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)",forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            switch response.statusCode {
                case 200:
                do {
                    return try JSONDecoder().decode([Artist].self, from: data)
                } catch  {
                    throw APIError.invalidData
                }
                case 403:
                    throw APIError.invalidToken
                case 500:
                    throw APIError.internalServerError
                default:
                    throw APIError.unknowStatusCodeError(statusCode: response.statusCode)
            }
        }catch {
            throw error
        }
    }
    
    func postArtist(artist: Artist, jwt: String) async throws -> Void {
        var request = URLRequest(url: URL(string: APIConstants.baseURL.appending("/auth/register"))!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(artist)
        do{
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            switch response.statusCode {
            case 201:
                return
            case 500:
                throw APIError.internalServerError
            default:
                throw APIError.unknowStatusCodeError(statusCode: response.statusCode)
            }
        }catch {
            throw error
            //throw GenericServiceError.serverUnreachable
        }
        
    }
}
