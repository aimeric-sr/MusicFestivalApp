//
//  User.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import Foundation

struct User : Codable {
    let id: UUID
    let username: String
    let email: String
    let created_on: Date
}

extension User {
    static let dummyData: [User] = [
        User(id: UUID(uuidString: "35564e6b-e9f3-4810-aa2e-f118c33cb1c1")!, username: "aimeric", email: "aimeric.sorin@gmail.com", created_on: DateFormatter().date(from: "2016-02-29 12:24:26")!),
        User(id: UUID(uuidString: "78564e6b-e9f3-4810-aa2e-f118c33cb1c1")!, username: "jean", email: "louis.sorin@gmail.com", created_on: DateFormatter().date(from: "2018-02-29 12:24:26")!)
    ]
}
