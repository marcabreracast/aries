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

import RealmSwift
class User: Object {
    @Persisted(primaryKey: true) var _id: String = ""
    @Persisted var _partition: String = ""
    @Persisted var email: String = ""
    @Persisted var name: String?
    
    convenience init(email: String) {
            self.init()
            self.email = email
        }
}
