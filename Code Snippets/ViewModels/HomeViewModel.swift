//
//  HomeViewModel.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 12.12.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class HomeViewModel: ObservableObject {
    @Published var posts: [Post] = [] // Alle Posts
    @Published var userPosts: [Post] = [] // Posts des aktuellen Benutzers
    @Published var snippets: [Snippet] = [] // Alle Snippets
    @Published var errorMessage: String? // Fehleranzeige

    private let firestoreRepository = FirestoreRepository()

    // MARK: - Funktionen

    /// Alle Posts laden
    func fetchAllPosts() async {
        do {
            self.posts = try await firestoreRepository.fetchPosts()
        } catch {
            self.errorMessage = "Fehler beim Laden der Posts: \(error.localizedDescription)"
        }
    }

    /// Posts eines bestimmten Benutzers laden
    func fetchPostsByUser(userId: String) async {
        do {
            let fetchedPosts = try await firestoreRepository.fetchPosts()
            self.userPosts = fetchedPosts.filter { $0.author.contains(userId) }
        } catch {
            self.errorMessage = "Fehler beim Laden der Benutzer-Posts: \(error.localizedDescription)"
        }
    }

    /// Logout-Funktion
    func logout() async throws {
        do {
            try Auth.auth().signOut()
            print("Benutzer erfolgreich ausgeloggt.")
        } catch {
            print("Fehler beim Logout: \(error.localizedDescription)")
            throw error
        }
    }

    /// Post erstellen mit Kategorie-ID
    func createPost(title: String, content: String, author: FirestoreUser, categoryId: String?) async throws {
        try await firestoreRepository.createPost(
            title: title,
            content: content,
            author: author,
            categoryId: categoryId
        )
        await fetchAllPosts() // Aktualisiere die Posts nach dem Erstellen
    }

    /// Neuen Post erstellen
    func createPost(title: String, content: String, author: FirestoreUser) async throws {
        try await firestoreRepository.createPost(title: title, content: content, author: author, categoryId: nil)
        await fetchAllPosts() // Aktualisiere die Posts nach dem Erstellen
    }

    /// Post löschen
    func deletePost(post: Post) async throws {
        guard let postId = post.id else {
            throw NSError(domain: "Firestore", code: 400, userInfo: [NSLocalizedDescriptionKey: "Post-ID fehlt."])
        }
        try await firestoreRepository.deletePost(postId: postId)
        await fetchAllPosts() // Aktualisiere die Posts nach dem Löschen
    }

    /// Reaktion zu einem Post hinzufügen
    func reactToPost(post: Post, reaction: String) async throws {
        guard let postId = post.id else {
            throw NSError(domain: "Firestore", code: 400, userInfo: [NSLocalizedDescriptionKey: "Post-ID fehlt."])
        }
        try await firestoreRepository.addReactionToPost(postId: postId, reaction: reaction)
        await fetchAllPosts() // Aktualisiere die Posts nach der Reaktion
    }

    /// Alle Snippets laden
    func fetchAllSnippets() async {
        do {
            self.snippets = try await firestoreRepository.fetchSnippets()
        } catch {
            self.errorMessage = "Fehler beim Laden der Snippets: \(error.localizedDescription)"
        }
    }

    /// Snippet löschen
    func deleteSnippet(snippet: Snippet) async throws {
        guard let snippetId = snippet.id else {
            throw NSError(domain: "Firestore", code: 400, userInfo: [NSLocalizedDescriptionKey: "Snippet-ID fehlt."])
        }
        try await firestoreRepository.deleteSnippet(snippetId: snippetId)
        await fetchAllSnippets() // Aktualisiere die Snippets nach dem Löschen
    }
}
