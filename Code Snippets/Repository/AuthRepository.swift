//
//  AuthRepository.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 10.12.24.
//

import Foundation
import FirebaseAuth


class AuthRepository {
    let auth = Auth.auth()
    @Published var user: User?


    func loginAnonymously() async  throws -> FirebaseAuth.User{
        do{
            let result = try await auth.signInAnonymously()
            return result.user

        }catch{
            print("Error: \(error.localizedDescription)")
            throw error

        }

    }
    func register(email: String, password: String) async throws -> FirebaseAuth.User {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            return result.user
        } catch {
            print("Error: \(error.localizedDescription)")
            throw error
        }
    }
    func login(email: String, password: String) async throws -> FirebaseAuth.User {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            return result.user
        } catch {
            print("Error: \(error.localizedDescription)")
            throw error
        }
    }
    func logout() throws {
        do {
            try auth.signOut()
            user = nil
            print("User logged out successfully.")
        } catch {
            print("Error during logout: \(error.localizedDescription)")
            throw error
        }
    }

}


//import FirebaseAuth
//// Importiert das Firebase Authentication Framework, das für die Authentifizierung verwendet wird.
//
//private var auth = Auth.auth()
//// Erstellt eine Instanz des Firebase-Authentifizierungsdienstes, die für die Authentifizierung von Benutzern verwendet wird.
//
//@Published var user: User?
//// Eine veröffentlichte Variable (für SwiftUI), die den aktuellen Benutzer speichert. Änderungen an dieser Variable können UI-Komponenten automatisch aktualisieren.
//
//func loginAnonymously() {
//    // Definiert eine Funktion, die einen anonymen Login über Firebase ermöglicht.
//
//    auth.signInAnonymously() { authResult, error in
//        // Ruft die Methode `signInAnonymously` der Firebase-Authentifizierungsinstanz auf.
//        // Diese Methode authentifiziert den Benutzer anonym und gibt ein `authResult` oder einen `error` zurück.
//
//        if let error {
//            // Überprüft, ob ein Fehler aufgetreten ist.
//            print("Login failed:", error.localizedDescription)
//            // Gibt eine Fehlermeldung in der Konsole aus, falls der Login fehlschlägt.
//            return
//            // Bricht die Ausführung der Funktion ab, wenn ein Fehler auftritt.
//        }
//
//        guard let authResult else { return }
//        // Überprüft, ob das `authResult` existiert (d. h. kein Fehler aufgetreten ist).
//        // Wenn nicht, wird die Funktion ohne weiteren Code ausgeführt (kein Benutzer wird gesetzt).
//
//        print("User is logged in with id '\(authResult.user.uid)'")
//        // Gibt die Benutzer-ID (`uid`) des authentifizierten anonymen Benutzers in der Konsole aus.
//
//        self.user = authResult.user
//        // Setzt die `user`-Variable auf den aktuell authentifizierten anonymen Benutzer.
//        // Dies kann in der UI verwendet werden, um anzuzeigen, dass der Benutzer eingeloggt ist.
//    }
//}
