import SwiftUI

struct StandardTintButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .buttonStyle(.bordered)
            .tint(.accentColor)
            .controlSize(.large)
    }
}



