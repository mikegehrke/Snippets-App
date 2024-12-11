//
//  AuthRepository.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 10.12.24.
//

// AuthRepository.swift
import Foundation
import Firebase
import FirebaseAuth

class AuthRepository {
    let auth = Auth.auth()

    func loginAnonymously() async throws -> FirebaseAuth.User {
        let result = try await auth.signInAnonymously()
        return result.user
    }

    func register(email: String, password: String) async throws -> FirebaseAuth.User {
        let result = try await auth.createUser(withEmail: email, password: password)
        return result.user
    }

    func login(email: String, password: String) async throws -> FirebaseAuth.User {
        let result = try await auth.signIn(withEmail: email, password: password)
        return result.user
    }

    func logout() throws {
        try auth.signOut()
        print("User logged out successfully.")
    }
}


