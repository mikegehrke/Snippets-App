//
//  FirestoreRepository.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 11.12.24.
//

import Foundation
import FirebaseFirestore

class FirestoreRepository {
    internal let db = Firestore.firestore() // Zugriff für Extensions
}

extension FirestoreRepository {
    /// Neues Snippet in Firestore speichern (mit Kategorie-ID)
    func createSnippet(title: String, code: String, userId: String, categoryId: String? = nil) async throws {
        var data: [String: Any] = [
            "title": title,
            "code": code,
            "userId": userId,
            "createdAt": Timestamp(date: Date())
        ]
        if let categoryId = categoryId {
            data["categoryId"] = categoryId
        }

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.collection("snippets").addDocument(data: data) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    /// Alle Snippets aus Firestore laden
    func fetchSnippets() async throws -> [Snippet] {
        let snapshot = try await db.collection("snippets").getDocuments()

        return snapshot.documents.compactMap { document in
            let data = document.data()
            let id = document.documentID
            let title = data["title"] as? String ?? ""
            let code = data["code"] as? String ?? ""
            let userId = data["userId"] as? String ?? ""
            let categoryId = data["categoryId"] as? String ?? nil

            return Snippet(id: id, title: title, code: code, userId: userId, categoryId: categoryId)
        }
    }

    /// Snippets nach Kategorie abrufen
    func fetchSnippetsByCategory(categoryId: String) async throws -> [Snippet] {
        let snapshot = try await db.collection("snippets")
            .whereField("categoryId", isEqualTo: categoryId)
            .getDocuments()

        return snapshot.documents.compactMap { document in
            let data = document.data()
            let id = document.documentID
            let title = data["title"] as? String ?? ""
            let code = data["code"] as? String ?? ""
            let userId = data["userId"] as? String ?? ""

            return Snippet(id: id, title: title, code: code, userId: userId, categoryId: categoryId)
        }
    }

    /// Firestore Listener hinzufügen
    func listenToSnippets(completion: @escaping (Result<[Snippet], Error>) -> Void) -> ListenerRegistration {
        return db.collection("snippets").addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let snippets = snapshot.documents.compactMap { document -> Snippet? in
                    let data = document.data()
                    let id = document.documentID
                    let title = data["title"] as? String ?? ""
                    let code = data["code"] as? String ?? ""
                    let userId = data["userId"] as? String ?? ""
                    let categoryId = data["categoryId"] as? String ?? nil

                    return Snippet(id: id, title: title, code: code, userId: userId, categoryId: categoryId)
                }
                completion(.success(snippets))
            }
        }
    }
}

extension FirestoreRepository {
    /// Snippet aus Firestore löschen
    func deleteSnippet(snippetId: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.collection("snippets").document(snippetId).delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}

extension FirestoreRepository {
    /// Kategorie erstellen
    func createCategory(name: String, userId: String) async throws {
        let data: [String: Any] = [
            "name": name,
            "userId": userId,
            "createdAt": Timestamp(date: Date())
        ]

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.collection("categories").addDocument(data: data) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    /// Kategorien abrufen
    func fetchCategories(userId: String) async throws -> [Category] {
        let snapshot = try await db.collection("categories").whereField("userId", isEqualTo: userId).getDocuments()
        return snapshot.documents.compactMap { document in
            let data = document.data()
            let id = document.documentID
            let name = data["name"] as? String ?? ""
            let userId = data["userId"] as? String ?? ""
            let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()

            return Category(id: id, name: name, userId: userId, createdAt: createdAt)
        }
    }

    /// Kategorie-Listener
    func listenToCategories(userId: String, completion: @escaping (Result<[Category], Error>) -> Void) -> ListenerRegistration {
        return db.collection("categories")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    let categories = snapshot.documents.compactMap { document -> Category? in
                        let data = document.data()
                        let id = document.documentID
                        let name = data["name"] as? String ?? ""
                        let userId = data["userId"] as? String ?? ""
                        let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()

                        return Category(id: id, name: name, userId: userId, createdAt: createdAt)
                    }
                    completion(.success(categories))
                }
            }
    }
}

extension FirestoreRepository {
    /// Kategorie einem Snippet zuweisen
    func assignCategoryToSnippet(snippetId: String, categoryId: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.collection("snippets").document(snippetId).updateData(["categoryId": categoryId]) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
