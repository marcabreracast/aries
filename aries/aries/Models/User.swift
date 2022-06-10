//
//  User.swift
//  aries
//
//  Created by Mar Cabrera on 02/06/2022.
//

import Foundation
import RealmSwift

// https://imthath.medium.com/an-easy-way-to-deep-copy-and-compare-objects-using-codable-in-swift-3095970990e5
// SLIDES - Add presentation focus to detail copy 
public protocol Imitable: Codable {
    var copy: Self? { get }
}

extension Imitable {
    public var copy: Self? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONDecoder().decode(Self.self, from: data)
    }
}

class User: Object, Codable {
    @Persisted(primaryKey: true) var _id: String = ""
    @Persisted var _partition: String = ""
    @Persisted var email: String
    @Persisted var launches: List<UserLaunches>
    @Persisted var name: String?

}

class UserLaunches: EmbeddedObject, Imitable {
    @Persisted var id: String?
    @Persisted var dateUnix: Double?
    @Persisted var details: String?
    @Persisted var name: String?
    @Persisted var upcoming: Bool?
    @Persisted var links: LaunchLinks?
    @Persisted var launchpad: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case details
        case dateUnix = "date_unix"
        case upcoming
        case links
        case launchpad
    }
}

class LaunchLinks: EmbeddedObject, Codable {
    @Persisted var youtubeId: String?

    enum CodingKeys: String, CodingKey {
        case youtubeId = "youtube_id"
    }
}

