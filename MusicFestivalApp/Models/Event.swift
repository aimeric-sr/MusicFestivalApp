//
//  Event.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import Foundation

struct Event : Codable {
    var id: UUID
    var name: String
    var location: String
    var started_date: Date
    var finish_date: Date
}
