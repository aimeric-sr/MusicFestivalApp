import Foundation

protocol EventServiceProt {
    func getEvents(accessToken: String) async throws -> [Event]
}

struct EventService : EventServiceProt {
    func getEvents(accessToken: String) async throws -> [Event] {
        var request = URLRequest(url: URL(string: APIConstants.baseURL.appending("/events"))!)
        request.setValue("Bearer \(accessToken)",forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        //custom formater to be able to format the date with the fraticonal seconds part
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)

        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            switch response.statusCode {
                case 200:
                    return try decoder.decode([Event].self, from: data)
                case 401:
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
}
