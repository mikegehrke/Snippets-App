//
//  Post.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 12.12.24.
//
import Foundation
import FirebaseFirestore

struct Post: Codable, Identifiable {
    @DocumentID var id: String?
    var author: String
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date
    var likes: Int
    var categoryId: String? // Neue Kategorie-ID für die Verknüpfung

       init(id: String? = nil, author: String, title: String, content: String, createdAt: Date, updatedAt: Date, likes: Int, categoryId: String? = nil) {
           self.id = id
           self.author = author
           self.title = title
           self.content = content
           self.createdAt = createdAt
           self.updatedAt = updatedAt
           self.likes = likes
           self.categoryId = categoryId
       }
   }

