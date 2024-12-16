//
//  SnippetViewModel.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 13.12.24.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class SnippetViewModel: ObservableObject {
    @Published var snippets: [Snippet] = [] // Alle Snippets
    @Published var errorMessage: String? // Fehleranzeige
    @Published var successMessage: String? // Erfolgsanzeige
    @Published var isLoading: Bool = false // Ladezustand

    private let firestoreRepository = FirestoreRepository()
    private var snippetListener: ListenerRegistration? // Listener-Referenz

    /// Funktion: Neues Snippet hinzufügen (mit optionaler Kategorie)
    func addSnippet(title: String, code: String, categoryId: String? = nil) async {
        do {
            let userId = Auth.auth().currentUser?.uid ?? "unknown"
            try await firestoreRepository.createSnippet(title: title, code: code, userId: userId, categoryId: categoryId)
            self.successMessage = "Snippet erfolgreich hinzugefügt!"
            self.errorMessage = nil // Fehler zurücksetzen
        } catch {
            self.successMessage = nil // Erfolgsnachricht zurücksetzen
            self.errorMessage = "Fehler beim Hinzufügen des Snippets: \(error.localizedDescription)"
        }
    }

    /// Funktion: Alle Snippets laden
    func fetchAllSnippets() async {
        self.isLoading = true
        do {
            self.snippets = try await firestoreRepository.fetchSnippets()
            self.errorMessage = nil // Erfolgreich, Fehler zurücksetzen
        } catch {
            self.errorMessage = "Fehler beim Laden der Snippets: \(error.localizedDescription)"
        }
        self.isLoading = false
    }

    /// Funktion: Snippets nach Kategorie laden
    func fetchSnippetsByCategory(categoryId: String) async {
        self.isLoading = true
        do {
            self.snippets = try await firestoreRepository.fetchSnippetsByCategory(categoryId: categoryId)
            self.errorMessage = nil // Erfolgreich, Fehler zurücksetzen
        } catch {
            self.errorMessage = "Fehler beim Laden der Snippets: \(error.localizedDescription)"
        }
        self.isLoading = false
    }

    /// Firestore Listener hinzufügen
    func listenToSnippets() {
        // Entferne vorherigen Listener, falls vorhanden
        removeSnippetListener()

        snippetListener = firestoreRepository.listenToSnippets { [weak self] (result: Result<[Snippet], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let snippets):
                    self?.snippets = snippets // Automatische Aktualisierung des Arrays
                case .failure(let error):
                    self?.errorMessage = "Fehler beim Abrufen der Snippets: \(error.localizedDescription)"
                }
            }
        }
    }

    /// Entferne den Firestore Listener
    func removeSnippetListener() {
        snippetListener?.remove()
        snippetListener = nil
    }

    /// Snippet löschen
    func deleteSnippet(snippet: Snippet) async throws {
        guard let snippetId = snippet.id else {
            throw NSError(domain: "Firestore", code: 400, userInfo: [NSLocalizedDescriptionKey: "Snippet-ID fehlt."])
        }
        try await firestoreRepository.deleteSnippet(snippetId: snippetId)
        await fetchAllSnippets() // Aktualisiere die Liste nach dem Löschen
    }
}
