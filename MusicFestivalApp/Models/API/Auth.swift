import Foundation

//Mark: - Login
struct LoginRequestBody : Codable {
    let username: String
    let password: String
}

struct LoginResponseBody : Codable {
    let accessToken: String?
    let refreshToken: String?
}

//Mark: - Register
struct RegisterRequestBody : Codable {
    let username: String
    let password: String
    let email: String
}

//Mark: - Tokens
struct RefreshTokenRequestBody : Codable {
    let refreshToken: String
}

struct RefreshTokenResponseBody : Codable {
    let accessToken: String
}
