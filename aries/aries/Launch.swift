//
//  Launch.swift
//  aries
//
//  Created by Mar Cabrera on 06/05/2022.
//

import Foundation

struct Launch: Codable {
    let name: String
    let dateLocal: String

    enum CodingKeys: String, CodingKey {
        case name
        case dateLocal = "date_local"
    }
}
