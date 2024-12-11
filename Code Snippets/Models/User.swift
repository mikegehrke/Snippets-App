//
//  User.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 10.12.24.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth

// User.swift
struct FirestoreUser: Codable {
    var id: String
    var email: String?
    var registeredOn: Date?
    var name: String?
    var birthDate: Date?
    var gender: String?
    var occupation: String?

    init(id: String, email: String?, registeredOn: Date?, name: String? = nil, birthDate: Date? = nil, gender: String? = nil, occupation: String? = nil) {
        self.id = id
        self.email = email
        self.registeredOn = registeredOn
        self.name = name
        self.birthDate = birthDate
        self.gender = gender
        self.occupation = occupation
    }
}
