//
//  Launch.swift
//  aries
//
//  Created by Mar Cabrera on 06/05/2022.
//

import Foundation

struct Launch: Codable {
    let name: String
    let details: String?
    let dateUnix: Double
    let upcoming: Bool
    let links: Links?

    enum CodingKeys: String, CodingKey {
        case name
        case details
        case dateUnix = "date_unix"
        case upcoming
        case links
    }
}

struct Links: Codable {
    let youtubeId: String?
    
    enum CodingKeys: String, CodingKey {
        case youtubeId = "youtube_id"
    }
}

