//
//  Category.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 13.12.24.
//

import Foundation
import FirebaseFirestore

struct Category: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var userId: String
    var createdAt: Date

    init(id: String? = nil, name: String, userId: String, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.userId = userId
        self.createdAt = createdAt
    }
}
