//
//  EventCellAdminView.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 23/12/2021.
//

import SwiftUI

struct EventCellAdminView: View {
    var event : EventViewModel
    var body: some View {
        HStack{
            Text("\(event.name)")
                .padding()
                .fixedSize()
            Spacer()
            VStack{
                Text("\(event.finishDate)")
                    .padding([.bottom, .top])
            }
        }
    }
}

struct EventCellAdminView_Previews: PreviewProvider {
    static var previews: some View {
        EventCellAdminView(event: EventViewModel(event: Event.dummyData[1]))
            
            .previewLayout(.sizeThatFits)
    }
}
