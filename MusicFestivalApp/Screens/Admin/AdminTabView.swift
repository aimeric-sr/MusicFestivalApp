import SwiftUI

struct AdminTabView: View {
    
    var body: some View {
        TabView {
            ArtistsAdminView()
                .tabItem {
                    Label("Artists", systemImage: "star")
                }
            
            EventsAdminView()
                .tabItem {
                    Label("Events", systemImage: "music.note.list")
                }
        }
    }
}

struct AdminTabView_Previews: PreviewProvider {
    static var previews: some View {
        AdminTabView()
    }
}
