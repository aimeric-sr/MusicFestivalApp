//
//  Event.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import Foundation

struct Event : Codable {
    let id: UUID
    let name: String
    let location: String
    let started_date: Date
    let finish_date: Date
}
