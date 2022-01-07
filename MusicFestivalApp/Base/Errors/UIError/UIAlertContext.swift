import SwiftUI

struct UIAlertContext {
    static let deleteArtistError = AlertItem(
        title: Text("No Artists Selected"),
        message: Text("Can't delete artist, please try to contact support."),
        dismissButton: .default(Text("OK")))
}

