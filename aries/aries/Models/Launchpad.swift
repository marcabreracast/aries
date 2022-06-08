//
//  Launchpad.swift
//  aries
//
//  Created by Mar Cabrera on 08/06/2022.
//

import Foundation

struct Launchpad: Codable {
    let id: String?
    let fullName: String?
    let locality: String?
    let latitude: Double?
    let longitude: Double?
    let details: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case locality
        case latitude
        case longitude
        case details
    }
}
