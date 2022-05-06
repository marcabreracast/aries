//
//  Launch.swift
//  aries
//
//  Created by Mar Cabrera on 06/05/2022.
//

import Foundation

struct UpcomingLaunches: Codable {
    var upcomingLaunches: Launch
}

struct Launch: Codable {
    let name: String
}
