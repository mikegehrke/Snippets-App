//
//  AuthViewModel.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 10.12.24.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    private var authRepository: AuthRepository
    @Published var user: FirebaseAuth.User?

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
        self.user = authRepository.auth.currentUser
    }

    func loginAnonymously() async {
        do {
            let result = try await authRepository.loginAnonymously()
            DispatchQueue.main.async {
                self.user = result
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func register(email: String, password: String) async {
        do {
            let result = try await authRepository.register(email: email, password: password)
            DispatchQueue.main.async {
                self.user = result
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func login(email: String, password: String) async {
        do {
            let result = try await authRepository.login(email: email, password: password)
            DispatchQueue.main.async {
                self.user = result
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func logout() async {
        do {
            try authRepository.logout()
            DispatchQueue.main.async {
                self.user = nil
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
