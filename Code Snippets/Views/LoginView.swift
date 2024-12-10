//
//  LoginView.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 10.12.24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Binding var path: NavigationPath // Verwendet den NavigationPath für die Navigation
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String? // Für Fehlermeldungen

    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .bold()

            // E-Mail Eingabefeld
            VStack(alignment: .leading) {
                TextField("E-Mail", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(email.isValidEmail ? Color.green : Color.red, lineWidth: 1)
                    )

                if !email.isValidEmail && !email.isEmpty {
                    Text("Ungültige E-Mail-Adresse.")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
            }

            // Passwort Eingabefeld
            VStack(alignment: .leading) {
                SecureField("Passwort", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(password.isValidPassword ? Color.green : Color.red, lineWidth: 1)
                    )

                if !password.isValidPassword && !password.isEmpty {
                    Text("Passwort muss mindestens 6 Zeichen, eine Zahl und ein Sonderzeichen enthalten.")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
            }

            // Fehlermeldung anzeigen
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            // Login-Button
            Button(action: {
                Task {
                    await userViewModel.login(email: email, password: password)
                    if let user = userViewModel.user {
                        path.append("HomeView")
                    } else {
                        errorMessage = userViewModel.errorMessage
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
            .padding(.horizontal)
            .disabled(!email.isValidEmail || !password.isValidPassword)

            // Anonym-Login-Button
            Button(action: {
                Task {
                    await userViewModel.loginAnonymously()
                    if let user = userViewModel.user {
                        path.append("HomeView")
                    } else {
                        errorMessage = userViewModel.errorMessage
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
