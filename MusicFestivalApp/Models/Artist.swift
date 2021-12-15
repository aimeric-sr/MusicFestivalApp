//
//  Artist.swift
//  MusicFestivalApp
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import Foundation

struct Artist : Codable {
    let id: UUID?
    let name: String
    let nationality: String
    let music_styles: String

}
