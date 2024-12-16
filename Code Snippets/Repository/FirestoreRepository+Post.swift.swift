//
//  FirestoreRepository+Post.swift.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 12.12.24.
//

import Foundation
import FirebaseFirestore

extension FirestoreRepository {
    /// Post in Firestore speichern
    func createPost(title: String, content: String, author: FirestoreUser, categoryId: String?) async throws {
        let data: [String: Any] = [
            "title": title,
            "content": content,
            "author": [
                "id": author.id,
                "name": author.name ?? ""
            ],
            "createdAt": Timestamp(date: Date()),
            "updatedAt": Timestamp(date: Date()),
            "likes": 0,
            "categoryId": categoryId ?? NSNull()
        ]

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.collection("posts").addDocument(data: data) { error in
                if let error = error {
                    continuation.resume(throwing: error) // Fehler an den Aufrufer weitergeben
                } else {
                    continuation.resume() // Erfolgreich
                }
            }
        }
    }

    /// Posts aus Firestore laden
    func fetchPosts() async throws -> [Post] {
        let snapshot = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<QuerySnapshot, Error>) in
            db.collection("posts").getDocuments { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error) // Fehler an den Aufrufer weitergeben
                } else if let snapshot = snapshot {
                    continuation.resume(returning: snapshot) // Snapshot zurückgeben
                }
            }
        }

        return snapshot.documents.compactMap { document in
            let data = document.data()
            let id = document.documentID
            let title = data["title"] as? String ?? ""
            let content = data["content"] as? String ?? ""
            let authorData = data["author"] as? [String: Any] ?? [:]
            let authorId = authorData["id"] as? String ?? ""
            let authorName = authorData["name"] as? String ?? ""
            let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
            let updatedAt = (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
            let likes = data["likes"] as? Int ?? 0

            return Post(
                id: id,
                author: "\(authorName) (\(authorId))",
                title: title,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
                likes: likes
            )
        }
    }

    /// Post löschen
    func deletePost(postId: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.collection("posts").document(postId).delete { error in
                if let error = error {
                    continuation.resume(throwing: error) // Fehler an den Aufrufer weitergeben
                } else {
                    continuation.resume() // Erfolgreich
                }
            }
        }
    }

    /// Reaktion zu einem Post hinzufügen
    func addReactionToPost(postId: String, reaction: String) async throws {
        let postRef = db.collection("posts").document(postId)

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            postRef.updateData([
                "reactions": FieldValue.arrayUnion([reaction])
            ]) { error in
                if let error = error {
                    continuation.resume(throwing: error) // Fehler an den Aufrufer weitergeben
                } else {
                    continuation.resume() // Erfolgreich
                }
            }
        }
    }
}
