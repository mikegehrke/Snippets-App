//
//  User.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 10.12.24.
//

// User.swift
import Foundation
import Firebase
import FirebaseAuth

// Hauptbenutzer-Modell
struct User: Identifiable, Codable {
    var id: String
    var email: String?
    var registeredOn: Date?

    init(id: String, email: String?, registeredOn: Date?) {
        self.id = id
        self.email = email
        self.registeredOn = registeredOn
    }
}

// Firestore-spezifisches Modell
struct FirestoreUser: Codable {
    var id: String
    var email: String?
    var registeredOn: Date?

    init(id: String, email: String?, registeredOn: Date?) {
        self.id = id
        self.email = email
        self.registeredOn = registeredOn
    }
}
