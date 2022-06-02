//
//  User.swift
//  aries
//
//  Created by Mar Cabrera on 02/06/2022.
//

import Foundation
import RealmSwift

class User: Object {
    @Persisted(primaryKey: true) var _id: String = ""

    @Persisted var _partition: String = ""

    @Persisted var email: String = ""

    @Persisted var launches: List<Launches> // Change name

    @Persisted var name: String?
    
    convenience init(name: String, email: String) {
            self.init()
            self.name = name
            self.email = email
            self.launches = List<Launches>()
            
        }
}

class Launches: EmbeddedObject {
    @Persisted var dateUnix: Double?

    @Persisted var details: String?

    @Persisted var id: String?

    @Persisted var name: String?
}
