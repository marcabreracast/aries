//
//  User.swift
//  aries
//
//  Created by Mar Cabrera on 02/06/2022.
//

import Foundation
import RealmSwift

class User: Object, Codable {
    @Persisted(primaryKey: true) var _id: String = ""
    @Persisted var _partition: String = ""
    @Persisted var email: String
    @Persisted var launches: List<UserLaunches>
    @Persisted var name: String?

}

class UserLaunches: EmbeddedObject, Codable {
    @Persisted var dateUnix: Double?
    @Persisted var details: String?
    @Persisted var id: String?
    @Persisted var name: String?
    @Persisted var upcoming: Bool?
    @Persisted var links: LaunchLinks?

    enum CodingKeys: String, CodingKey {
        case name
        case details
        case dateUnix = "date_unix"
        case upcoming
        case links
    }
}

class LaunchLinks: EmbeddedObject, Codable {
    @Persisted var youtubeId: String?

    enum CodingKeys: String, CodingKey {
        case youtubeId = "youtube_id"
    }
}
