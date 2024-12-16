//
//  Snippet.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 13.12.24.
//

import Foundation
import FirebaseFirestore

struct Snippet: Codable, Identifiable {
    @DocumentID var id: String? // Eindeutige Kennung (optional)
    var title: String // Name des Snippets
    var code: String // Der eigentliche Code des Snippets
    var userId: String // Die ID des Benutzers, der das Snippet erstellt hat
    var categoryId: String? // Verweis auf Kategorie

    // Initializer für das Modell
    init(id: String? = nil, title: String, code: String, userId: String, categoryId: String? = nil) {
        self.id = id
        self.title = title
        self.code = code
        self.userId = userId
        self.categoryId = categoryId

    }
}
