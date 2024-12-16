//
//  FirestoreRepository+User.swift.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 12.12.24.
//
import Foundation
import FirebaseFirestore

extension FirestoreRepository {
    /// Benutzer in Firestore speichern
    func createUser(user: FirestoreUser) async throws {
        let data: [String: Any] = [
            "id": user.id,
            "email": user.email ?? "",
            "registeredOn": Timestamp(date: user.registeredOn ?? Date()),
            "name": user.name ?? "",
            "birthDate": user.birthDate != nil ? Timestamp(date: user.birthDate!) : NSNull(),
            "gender": user.gender ?? "",
            "occupation": user.occupation ?? ""
        ]

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.collection("users").document(user.id).setData(data) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    /// Benutzer aus Firestore laden
    func fetchUser(id: String) async throws -> FirestoreUser {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<FirestoreUser, Error>) in
            db.collection("users").document(id).getDocument { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = snapshot?.data() {
                    let id = data["id"] as? String ?? ""
                    let email = data["email"] as? String
                    let registeredOn = (data["registeredOn"] as? Timestamp)?.dateValue()
                    let name = data["name"] as? String
                    let birthDate = (data["birthDate"] as? Timestamp)?.dateValue()
                    let gender = data["gender"] as? String
                    let occupation = data["occupation"] as? String

                    let user = FirestoreUser(
                        id: id,
                        email: email,
                        registeredOn: registeredOn,
                        name: name,
                        birthDate: birthDate,
                        gender: gender,
                        occupation: occupation
                    )
                    continuation.resume(returning: user)
                } else {
                    continuation.resume(throwing: NSError(
                        domain: "Firestore",
                        code: 404,
                        userInfo: [NSLocalizedDescriptionKey: "Benutzer nicht gefunden"]
                    ))
                }
            }
        }
    }
}
