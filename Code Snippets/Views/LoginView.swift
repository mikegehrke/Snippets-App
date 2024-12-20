//
//  LoginView.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 10.12.24.
//

import SwiftUI
import FirebaseAuth

// MARK: - Login View
struct LoginView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Binding var path: NavigationPath
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String? // Fehlermeldung anzeigen

    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .bold()

            // E-Mail Eingabefeld
            TextField("E-Mail", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(email.isValidEmail ? Color.green : Color.red, lineWidth: 1)
                )

            // Passwort Eingabefeld
            SecureField("Passwort", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(password.isValidPassword ? Color.green : Color.red, lineWidth: 1)
                )

            // Fehlermeldung anzeigen
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            // Login-Button
            Button(action: {
                Task {
                    do {
                        try await userViewModel.login(email: email, password: password)
                        path.append("HomeView") // Navigation zur HomeView
                    } catch {
                        errorMessage = "Login fehlgeschlagen: \(error.localizedDescription)"
                    }
                }
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(email.isValidEmail && password.isValidPassword ? Color.blue : Color.gray)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            .disabled(!email.isValidEmail || !password.isValidPassword)
            .padding(.horizontal)

            // Anonym-Login-Button
            Button(action: {
                Task {
                    do {
                        try await userViewModel.loginAnonymously()
                        path.append("HomeView") // Navigation zur HomeView
                    } catch {
                        errorMessage = "Anonymes Login fehlgeschlagen: \(error.localizedDescription)"
                    }
                }
            }) {
                Text("Anonym einloggen")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)

            // Button zur Registrierung
            Button(action: {
                userViewModel.isRegister = true
            }) {
                Text("Noch keinen Account? Jetzt registrieren")
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}

#Preview {
    let previewViewModel = UserViewModel()
    LoginView(path: .constant(NavigationPath()))
        .environmentObject(previewViewModel)
}
