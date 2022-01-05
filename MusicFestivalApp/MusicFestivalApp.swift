import SwiftUI

@main
struct MusicFestivalApp: App {
    
    var userInfo = UserSensitiveData(secureStore: SecureStore())
    
    init() {
        do {
            try userInfo.checkFirstRun()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView() {
                if (userInfo.isAdmin()){
                    AdminTabView().environmentObject(userInfo)
                }
                else if (userInfo.isBasic()){
                    UserTabView().environmentObject(userInfo)
                }
                else {
                    LoginView().environmentObject(userInfo)
                }
            }
        }
    }
}
