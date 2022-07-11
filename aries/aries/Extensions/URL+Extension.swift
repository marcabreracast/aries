//
//  URL+Extension.swift
//  aries
//
//  Created by Mar Cabrera on 11/07/2022.
//

import Foundation

extension URL {
    // Function that returns a specific query parameter from the URL
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }

        return url.queryItems?.first(where: {$0.name == queryParameterName})?.value
    }
}
