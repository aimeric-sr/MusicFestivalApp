import Foundation

struct LoginRequestBody : Codable {
    let username: String
    let password: String
}

struct LoginResponseBody : Codable {
    let accessToken: String?
    let refreshToken: String?
}

struct RegisterRequestBody : Codable {
    let username: String
    let password: String
    let email: String
}

struct RefreshTokenRequestBody : Codable {
    let refreshToken: String
}

struct RefreshTokenResponseBody : Codable {
    let accessToken: String
}

protocol AuthServiceProtocol {
    func login(username: String, password: String) async throws -> LoginResponseBody
    func register(username: String, password: String, email: String) async throws -> Void
    func getAccessToken(refreshToken: String) async throws -> RefreshTokenResponseBody
}

class AuthService : AuthServiceProtocol{
    func login(username: String, password: String) async throws -> LoginResponseBody {
        let loginBody = LoginRequestBody(username: username, password: password)
        guard let url = URL(string: APIConstants.baseURL.appending("/auth/login")) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(loginBody)
        } catch {
            throw APIError.invalidDataSend
        }
        
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            switch response.statusCode {
            case 200:
                do {
                    return try JSONDecoder().decode(LoginResponseBody.self, from: data)
                } catch  {
                    throw APIError.invalidData
                }
            case 400:
                throw APIError.invalidPassword
            case 404:
                throw APIError.invalidUsername
            case 500:
                throw APIError.internalServerError
            default:
                throw APIError.unknowStatusCodeError(statusCode: response.statusCode)
            }
        }catch {
            throw error
        }
    }
    
    func register(username: String, password: String, email: String) async throws -> Void {
        let registerBody = RegisterRequestBody(username: username, password: password, email: email)
        guard let url = URL(string: APIConstants.baseURL.appending("/auth/register")) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(registerBody)
        } catch {
            throw APIError.invalidDataSend
        }
        
        do {
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
        }
    }
    
    func getAccessToken(refreshToken: String) async throws -> RefreshTokenResponseBody {
        let refreshTokenBody = RefreshTokenRequestBody(refreshToken: refreshToken)
        guard let url = URL(string: APIConstants.baseURL.appending("/auth/token")) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(refreshTokenBody)
        } catch {
            throw APIError.invalidDataSend
        }
        
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            switch response.statusCode {
            case 200:
                do {
                    return try JSONDecoder().decode(RefreshTokenResponseBody.self, from: data)
                } catch  {
                    throw APIError.invalidData
                }
            case 404:
                throw APIError.notFound
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
