//
//  Artist.swift
//  MusicFestivalApp
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import Foundation

struct Artist : Codable {
    var id: UUID
    var name: String
    var nationality: String
    var music_styles: String
}
