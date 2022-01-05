//
//  APButton.swift
//  Appetizers
//
//  Created by Aimeric Sorin on 27/12/2021.
//

import SwiftUI

struct APButton: View {
    let title : LocalizedStringKey
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .frame(width: 260, height: 50)
            .foregroundColor(.white)
            .background(Color.accentColor)
//            .background(Color.brandPrimary)
            .cornerRadius(10)
    }
}

struct APButton_Previews: PreviewProvider {
    static var previews: some View {
        APButton(title: "test")
            .preferredColorScheme(.light)
    }
}
