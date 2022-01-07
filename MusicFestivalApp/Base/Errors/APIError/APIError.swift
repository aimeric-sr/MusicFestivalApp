import Foundation

enum APIError: Error{
    case invalidURL
    case invalidDataSend
    case invalidResponse
    case invalidData
    case invalidUsername
    case invalidPassword
    case invalidToken
    case notFound
    case internalServerError
    case unknowStatusCodeError(statusCode: Int)
}

