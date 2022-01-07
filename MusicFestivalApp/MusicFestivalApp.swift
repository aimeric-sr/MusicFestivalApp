import SwiftUI

@main
struct MusicFestivalApp: App {
    
    var keyChainData = KeyChainManager(secureStore: SecureStore())
    
    init() {
        keyChainData.checkFirstRun()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView() {
                if (keyChainData.isAdmin()){
                    AdminTabView()
                }
                else if (keyChainData.isBasic()){
                    UserTabView()
                }
                else {
                    LoginView()
                }
            }
        }
    }
}
