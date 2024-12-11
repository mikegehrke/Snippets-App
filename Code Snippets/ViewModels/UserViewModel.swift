//
//  AuthViewModel.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 10.12.24.
//

// UserViewModel.swift
import Foundation
import FirebaseAuth
import SwiftUI

@MainActor
class UserViewModel: ObservableObject {
    @Published var user: FirestoreUser? // Aktueller Benutzer als FirestoreUser
    @Published var errorMessage: String? // Fehleranzeige
    @Published var path = NavigationPath() // Navigation
    private let firestoreRepository = FirestoreRepository() // Firestore-Zugriff
    @Published var isRegister: Bool = false // Steuerung für Login/Registrierung

    // MARK: - Funktionen

    /// Methode zum Wechseln zurück zum Login
    func switchToLogin() {
        isRegister = false
    }

    /// Registrierung eines neuen Benutzers
    func register(email: String, password: String, name: String, birthDate: Date, gender: String, occupation: String) async throws {
        guard email.isValidEmail else {
            throw RegistrationError.invalidEmail
        }
        guard password.isValidPassword else {
            throw RegistrationError.invalidPassword
        }
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let id = result.user.uid

            // Benutzer speichern und laden
            let newUser = FirestoreUser(
                id: id,
                email: email,
                registeredOn: Date(),
                name: name,
                birthDate: birthDate,
                gender: gender,
                occupation: occupation
            )
            try await firestoreRepository.createUser(user: newUser)
            try await fetchUser(id: id)

            self.path.append("HomeView") // Weiterleitung zur HomeView
        } catch {
            throw RegistrationError.authError(error.localizedDescription)
        }
    }

    /// Login eines vorhandenen Benutzers
    func login(email: String, password: String) async throws {
        guard email.isValidEmail else {
            throw LoginError.invalidEmail
        }
        guard password.isValidPassword else {
            throw LoginError.invalidPassword
        }
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let id = result.user.uid

            // Benutzerinformationen laden
            try await fetchUser(id: id)

            self.path.append("HomeView") // Weiterleitung zur HomeView
        } catch {
            throw LoginError.authError(error.localizedDescription)
        }
    }

    /// Anonyme Anmeldung
    func loginAnonymously() async throws {
        do {
            let result = try await Auth.auth().signInAnonymously()
            let id = result.user.uid

            // Benutzer speichern und laden
            let anonymousUser = FirestoreUser(
                id: id,
                email: nil,
                registeredOn: Date(),
                name: nil,
                birthDate: nil,
                gender: nil,
                occupation: nil
            )
            try await firestoreRepository.createUser(user: anonymousUser)
            try await fetchUser(id: id)

            self.path.append("HomeView")
        } catch {
            throw AuthError.anonymousLoginFailed(error.localizedDescription)
        }
    }

    /// Benutzerinformationen aus Firestore laden
    func fetchUser(id: String) async throws {
        do {
            let fetchedUser = try await firestoreRepository.fetchUser(id: id)
            self.user = fetchedUser
        } catch {
            throw LoginError.authError("Fehler beim Laden des Benutzers: \(error.localizedDescription)")
        }
    }

    /// Logout
    func logout() async throws {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.path = NavigationPath()
        } catch {
            throw LogoutError.failedToLogout(error.localizedDescription)
        }
    }
}
