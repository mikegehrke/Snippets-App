//
//  FirestoreRepository.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 11.12.24.
//

// FirestoreRepository.swift
import Foundation
import FirebaseFirestore

class FirestoreRepository {
    let db = Firestore.firestore()

    /// Benutzer in Firestore speichern
    func createUser(id: String, email: String) async throws {
        let user = FirestoreUser(id: id, email: email, registeredOn: Date()) // Benutzerobjekt erstellen

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            // Daten für Firestore formatieren
            let data: [String: Any] = [
                "id": user.id,
                "email": user.email ?? "",
                "registeredOn": Timestamp(date: user.registeredOn ?? Date()) // Korrekte Konvertierung in Timestamp
            ]

            // Daten in Firestore speichern
            db.collection("users").document(id).setData(data) { error in
                if let error = error {
                    continuation.resume(throwing: error) // Fehler übergeben
                } else {
                    continuation.resume() // Erfolgreich abgeschlossen
                }
            }
        }
    }

    /// Benutzer aus Firestore laden
    func fetchUser(id: String) async throws -> FirestoreUser {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<FirestoreUser, Error>) in
            db.collection("users").document(id).getDocument { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error) // Fehler übergeben
                } else if let data = snapshot?.data() {
                    // Daten aus Firestore extrahieren
                    let id = data["id"] as? String ?? ""
                    let email = data["email"] as? String
                    let registeredOn = (data["registeredOn"] as? Timestamp)?.dateValue() // Timestamp in Date konvertieren

                    // Benutzerobjekt erstellen
                    let user = FirestoreUser(id: id, email: email, registeredOn: registeredOn)
                    continuation.resume(returning: user) // Benutzer zurückgeben
                } else {
                    continuation.resume(throwing: NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Benutzer nicht gefunden"]))
                }
            }
        }
    }
}
