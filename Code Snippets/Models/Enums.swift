//
//  Enums.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 11.12.24.
//

import Foundation

// MARK: - Fehlerarten
enum RegistrationError: Error, LocalizedError {
    case invalidEmail
    case invalidPassword
    case authError(String)

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Ungültige E-Mail-Adresse."
        case .invalidPassword:
            return "Passwortanforderungen nicht erfüllt."
        case .authError(let message):
            return "Registrierungsfehler: \(message)"
        }
    }
}

enum LoginError: Error, LocalizedError {
    case invalidEmail
    case invalidPassword
    case authError(String)

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Ungültige E-Mail-Adresse."
        case .invalidPassword:
            return "Passwort ungültig."
        case .authError(let message):
            return "Login-Fehler: \(message)"
        }
    }
}

enum AuthError: Error, LocalizedError {
    case anonymousLoginFailed(String)

    var errorDescription: String? {
        switch self {
        case .anonymousLoginFailed(let message):
            return "Anonymer Login-Fehler: \(message)"
        }
    }
}

enum LogoutError: Error, LocalizedError {
    case failedToLogout(String)

    var errorDescription: String? {
        switch self {
        case .failedToLogout(let message):
            return "Logout-Fehler: \(message)"
        }
    }
}
