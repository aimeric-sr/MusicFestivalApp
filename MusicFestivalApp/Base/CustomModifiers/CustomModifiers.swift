//
//  CustomModifiers.swift
//  Appetizers
//
//  Created by Aimeric Sorin on 27/12/2021.
//

import SwiftUI

struct StandardButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.bordered)
            .tint(.accentColor)
            .controlSize(.large)
    }
}

//struct ImageCellStyle: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .frame(width: 120, height: 90)
//            .cornerRadius(8)
//    }
//}



