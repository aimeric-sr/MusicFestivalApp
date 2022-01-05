//
//  Test.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 05/01/2022.
//

import SwiftUI

struct Test: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Salut")
            }.navigationTitle("Tests")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("pressed")
                        } label: {
                            Text("test")
                                .foregroundColor(.white)
                                .background(.red)
                        }
                    }
                }
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
