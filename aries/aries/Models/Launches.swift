//
//  Launches.swift
//  aries
//
//  Created by Mar Cabrera on 13/06/2022.
//

import Foundation
import RealmSwift

class IDObject: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    
    override class func primaryKey() -> String? {
        return "_id"
    }
    
    override class func shouldIncludeInDefaultSchema() -> Bool {
        self != IDObject.self
    }
}


class Launch: IDObject {
 //   @Persisted(primaryKey: true) var _id: ObjectId

    @Persisted var _partition: String = ""

    @Persisted var auto_update: Bool?

    @Persisted var capsules: List<String>

    @Persisted var cores: List<Launch_cores>

    @Persisted var crew: List<String>

    @Persisted var date_local: String?

    @Persisted var date_precision: String?

    @Persisted var date_unix: Double?

    @Persisted var date_utc: String?

    @Persisted var details: String?

    @Persisted var failures: List<Launch_failures>

    @Persisted var fairings: Launch_fairings?

    @Persisted var flight_number: Double?

 //   @Persisted var id: String?

    @Persisted var launch_library_id: String?

    @Persisted var launchpad: String?

    @Persisted var links: Launch_links?

    @Persisted var name: String?

    @Persisted var net: Bool?

    @Persisted var payloads: List<String>

    @Persisted var rocket: String?

    @Persisted var ships: List<String>

    @Persisted var static_fire_date_unix: Double?

    @Persisted var static_fire_date_utc: String?

    @Persisted var success: Bool?

    @Persisted var tbd: Bool?

    @Persisted var upcoming: Bool?

    @Persisted var window: Double?
}

class Launch_cores: EmbeddedObject {
    @Persisted var core: String?

    @Persisted var flight: Double?

    @Persisted var gridfins: Bool?

    @Persisted var landing_attempt: Bool?

    @Persisted var landing_success: Bool?

    @Persisted var landing_type: String?

    @Persisted var landpad: String?

    @Persisted var legs: Bool?

    @Persisted var reused: Bool?
}

class Launch_failures: EmbeddedObject {
    @Persisted var altitude: Double?

    @Persisted var reason: String?

    @Persisted var time: Double?
}

class Launch_fairings: EmbeddedObject {
    @Persisted var recovered: Bool?

    @Persisted var recovery_attempt: Bool?

    @Persisted var reused: Bool?

    @Persisted var ships: List<String>
}

class Launch_links: EmbeddedObject {
    @Persisted var article: String?

    @Persisted var flickr: Launch_links_flickr?

    @Persisted var patch: Launch_links_patch?

    @Persisted var presskit: String?

    @Persisted var reddit: Launch_links_reddit?

    @Persisted var webcast: String?

    @Persisted var wikipedia: String?

    @Persisted var youtube_id: String?
}

class Launch_links_flickr: EmbeddedObject {
    @Persisted var original: List<String>
}

class Launch_links_patch: EmbeddedObject {
    @Persisted var large: String?

    @Persisted var small: String?
}

class Launch_links_reddit: EmbeddedObject {
    @Persisted var campaign: String?

    @Persisted var launch: String?

    @Persisted var media: String?

    @Persisted var recovery: String?
}

