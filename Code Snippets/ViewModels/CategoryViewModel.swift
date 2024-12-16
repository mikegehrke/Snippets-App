//
//  CategoryViewModel.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 13.12.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = [] // Alle Kategorien
    @Published var errorMessage: String? // Fehleranzeige
    @Published var successMessage: String? // Erfolgsanzeige
    @Published var isLoading: Bool = false // Ladezustand

    private var categoryListener: ListenerRegistration? // Listener-Referenz
    private let firestoreRepository = FirestoreRepository()

    /// Kategorie erstellen
    func addCategory(name: String) async {
        do {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            try await firestoreRepository.createCategory(name: name, userId: userId)
            self.successMessage = "Kategorie erfolgreich erstellt!"
            self.errorMessage = nil // Fehler zurücksetzen
        } catch {
            self.successMessage = nil // Erfolgsnachricht zurücksetzen
            self.errorMessage = "Fehler beim Erstellen der Kategorie: \(error.localizedDescription)"
        }
    }

    /// Kategorien laden
    func fetchCategories() async {
        self.isLoading = true
        do {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            self.categories = try await firestoreRepository.fetchCategories(userId: userId)
            self.errorMessage = nil // Erfolgreich, Fehler zurücksetzen
        } catch {
            self.errorMessage = "Fehler beim Laden der Kategorien: \(error.localizedDescription)"
        }
        self.isLoading = false
    }

    /// Kategorie nach ID abrufen
    func fetchCategoryById(categoryId: String) -> Category? {
        return categories.first { $0.id == categoryId }
    }

    /// Kategorie-Listener
    func listenToCategories() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        removeCategoryListener() // Vorherigen Listener entfernen
        categoryListener = firestoreRepository.listenToCategories(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self?.categories = categories
                case .failure(let error):
                    self?.errorMessage = "Fehler beim Laden der Kategorien: \(error.localizedDescription)"
                }
            }
        }
    }

    /// Kategorie-Listener entfernen
    func removeCategoryListener() {
        categoryListener?.remove()
        categoryListener = nil
    }
}
