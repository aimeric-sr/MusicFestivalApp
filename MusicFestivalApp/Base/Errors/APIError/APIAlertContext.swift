import SwiftUI

struct APIAlertContext {
    static let invalidURL = AlertItem(
        title: Text("Server Error"),
        message: Text("Unable to contact the server, please try to contact support."),
        dismissButton: .default(Text("OK")))
    
    static let invalidDataSend = AlertItem(
        title: Text("Server Error"),
        message: Text("Unable to sent information to the server, please try to contact support."),
        dismissButton: .default(Text("OK")))
    
    static let invalidResponse = AlertItem(
        title: Text("Server Error"),
        message: Text("Invalid response from the server. Please try again later or contact support."),
        dismissButton: .default(Text("OK")))
    
    static let invalidData = AlertItem(
        title: Text("Server Error"),
        message: Text("The data received from the server was invalid. Please contact support."),
        dismissButton: .default(Text("OK")))
    
    static let invalidUsername = AlertItem(
        title: Text("Server Error"),
        message: Text("User not found with this username."),
        dismissButton: .default(Text("OK")))
    
    static let invalidPassword = AlertItem(
        title: Text("Server Error"),
        message: Text("Wrong password, please try another."),
        dismissButton: .default(Text("OK")))
    
    static let invalidToken = AlertItem(
        title: Text("Server Error"),
        message: Text("Can't authentificate on the server. If this persiste, please contact support."),
        dismissButton: .default(Text("OK")))
    
    static let internalServerError = AlertItem(
        title: Text("Server Error"),
        message: Text("There was a issue with the server. If this persiste, please contact support."),
        dismissButton: .default(Text("OK")))
    
    static let unknowStatusCodeError = AlertItem(
        title: Text("Server Error"),
        message: Text("Unkown response from the server. Please try to contact support."),
        dismissButton: .default(Text("OK")))
    
    static let unableToComplete = AlertItem(
        title: Text("Server Error"),
        message: Text("Unable to complet your request at this time, the server is unreachable."),
        dismissButton: .default(Text("OK")))
    
    static let unknowError = AlertItem(
        title: Text("Server Error"),
        message: Text("Someting unexpected happened, please check your internet connection and contact the support."),
        dismissButton: .default(Text("OK")))
}
