//
//  AuthViewModel.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 10.12.24.
//

import Foundation
import FirebaseAuth
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var user: FirebaseAuth.User?
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isRegister: Bool = false
    @Published var errorMessage: String? // Für Fehlermeldungen
    @Published var path = NavigationPath() // NavigationPath statt [String]

        func navigateToHome() {
            path.append("HomeView") // Füge HomeView zur Navigation hinzu
        }

        func resetNavigation() {
            path = NavigationPath() // Setze die Navigation zurück
        }
    @Published var isValidEmail: Bool = false {
        didSet {
            if !isValidEmail {
                email = ""
            }
        }
    }

    var isPasswordValid: Bool {
        return password.isValidPassword &&
               password.containsSpecialCharacter &&
               password.containsNumber &&
               password.containsUppercase
    }

    init() {
        self.user = Auth.auth().currentUser
    }

    /// Überprüft, ob ein Benutzer eingeloggt ist
    func checkCurrentUser() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No user currently logged in.")
            return
        }
        self.user = currentUser
        print("User already logged in with ID: \(currentUser.uid)")
    }

    /// Anonymer Login
    func loginAnonymously() async {
        do {
            let result = try await Auth.auth().signInAnonymously()
            self.user = result.user
            self.path.append("HomeView") // Navigiere nach HomeView
            print("Anonymous login successful with ID: \(result.user.uid)")
        } catch {
            self.errorMessage = "Anonymous login failed: \(error.localizedDescription)"
            print(self.errorMessage!)
        }
    }

    /// Registrierung eines neuen Benutzers
    func register(email: String, password: String) async {
        guard isValidEmail, isPasswordValid else {
            self.errorMessage = "Invalid email or password"
            return
        }

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.user = result.user
            self.path.append("HomeView") // Navigiere nach HomeView
            print("Registration successful with email: \(result.user.email ?? "Unknown Email")")
        } catch {
            self.errorMessage = "Registration failed: \(error.localizedDescription)"
            print(self.errorMessage!)
        }
    }

    /// Login eines bestehenden Benutzers
    func login(email: String, password: String) async {
        guard isValidEmail, isPasswordValid else {
            self.errorMessage = "Invalid email or password"
            return
        }

        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = result.user
            self.path.append("HomeView") // Navigiere nach HomeView
            print("Login successful with email: \(result.user.email ?? "Unknown Email")")
        } catch {
            self.errorMessage = "Login failed: \(error.localizedDescription)"
            print(self.errorMessage!)
        }
    }

    /// Logout des aktuellen Benutzers
    func logout() async {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.path.removeLast(path.count) // Navigationspfad zurücksetzen
            print("Logout successful")
        } catch {
            self.errorMessage = "Logout failed: \(error.localizedDescription)"
            print(self.errorMessage!)
        }
    }

    /// Registrierung umschalten und ausführen
    func toggleRegistration() async {
        isRegister.toggle()
        if isRegister {
            await register(email: email, password: password)
        }
    }
}
