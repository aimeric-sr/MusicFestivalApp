//
//  User.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import Foundation

struct User : Codable {
    var id: UUID
    var username: String
    var email: String
    var created_on: Date
}
