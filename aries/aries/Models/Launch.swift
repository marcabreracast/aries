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

    enum CodingKeys: String, CodingKey {
        case name
        case details
        case dateUnix = "date_unix"
        case upcoming
    }
}
