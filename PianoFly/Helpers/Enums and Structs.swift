//
//  Enums and Structs.swift
//  PianoFly
//
//  Created by Derek Hsieh on 6/10/21.
//

import Foundation

struct CurrentUserDefaults {
    static let userID = "user_id"
    static let firstName = "first_name"
    static let lastName = "last_name"
    static let email = "email"
}

struct DatabaseUserField {
    static let firstName = "firstN"
    static let lastName = "lastN"
    static let email = "email"
    static let providerdID = "provider_id"
}

struct FirestoreDocumentCollectionNames {
    static let practice = "Practice"
    static let log = "Log"
}

struct DatabasePostField {
    static let postID = "post_id"
    static let practiceMinutes = "practice_minutes"
    static let dateCreated = "date_created"
}
