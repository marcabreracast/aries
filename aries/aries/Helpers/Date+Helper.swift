//
//  Date+Helper.swift
//  aries
//
//  Created by Mar Cabrera on 07/05/2022.
//

import Foundation

class DateHelper {
    
static func formatShortUnixDate(date: Double) -> String {
    let dateFormatter = DateFormatter()
    let dateUnformatted = Date(timeIntervalSince1970: date)
    
    dateFormatter.calendar = Calendar(identifier: .iso8601)
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000XXXXX"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.dateStyle = .medium

    let dateFormatted = dateFormatter.string(from: dateUnformatted)
    return dateFormatted
    }
}
