//
//  Date+Helper.swift
//  aries
//
//  Created by Mar Cabrera on 07/05/2022.
//

import Foundation

class DateHelper {
    
    static func formatISODate(date: String) -> String {
         let formatter = DateFormatter()
         formatter.locale = Locale(identifier: "en_US_POSIX")
         formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
         guard let formattedDate = formatter.date(from: date) else { return ""}
        
        let date = formatter.string(from: formattedDate )
        return date
    }
}
