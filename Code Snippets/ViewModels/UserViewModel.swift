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
    @Published var path = NavigationPath() // NavigationPath für NavigationStack
    @Published var errorMessage: String? // Fehlermeldungen

    var isEmailValid: Bool {
        email.isValidEmail
    }

    var isPasswordValid: Bool {
        password.isValidPassword &&
        password.containsSpecialCharacter &&
        password.containsNumber &&
        password.containsUppercase
    }

    func loginAnonymously() async {
        do {
            let result = try await Auth.auth().signInAnonymously()
            self.user = result.user
            self.path.append("HomeView")
        } catch {
            self.errorMessage = "Anonymes Login fehlgeschlagen: \(error.localizedDescription)"
        }
    }

    func register(email: String, password: String) async {
        guard isEmailValid else {
            self.errorMessage = "Ungültige E-Mail-Adresse."
            return
        }

        guard isPasswordValid else {
            self.errorMessage = "Passwort muss mindestens 6 Zeichen, eine Zahl, ein Sonderzeichen und einen Großbuchstaben enthalten."
            return
        }

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.user = result.user
            self.path.append("HomeView")
        } catch {
            self.errorMessage = "Registrierung fehlgeschlagen: \(error.localizedDescription)"
        }
    }

    func login(email: String, password: String) async {
        guard isEmailValid else {
            self.errorMessage = "Ungültige E-Mail-Adresse."
            return
        }

        guard isPasswordValid else {
            self.errorMessage = "Passwort ungültig."
            return
        }

        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = result.user
            self.path.append("HomeView")
        } catch {
            self.errorMessage = "Login fehlgeschlagen: \(error.localizedDescription)"
        }
    }

    func logout() async {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.path = NavigationPath()
        } catch {
            self.errorMessage = "Logout fehlgeschlagen: \(error.localizedDescription)"
        }
    }
}
