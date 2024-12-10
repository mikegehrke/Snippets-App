//
//  RegistrationView.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 10.12.24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct RegisterView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Binding var path: NavigationPath // NavigationPath für die Navigation
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String? // Fehlermeldung anzeigen

    var body: some View {
        VStack(spacing: 20) {
            Text("Registrieren")
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

            // Registrierung-Button
            Button(action: {
                Task {
                    await userViewModel.register(email: email, password: password)
                    if userViewModel.user != nil {
                        path.append("HomeView") // Navigation zur HomeView
                    } else {
                        errorMessage = userViewModel.errorMessage
                    }
                }
            }) {
                Text("Registrieren")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(email.isValidEmail && password.isValidPassword ? Color.orange : Color.gray)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            .disabled(!email.isValidEmail || !password.isValidPassword)
            .padding(.horizontal)

            // Button zurück zum Login
            Button(action: {
                userViewModel.isRegister = false // Zurück zur LoginView
            }) {
                Text("Bereits einen Account? Jetzt einloggen")
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}
#Preview {
    let previewViewModel = UserViewModel()
    RegisterView(path: .constant(NavigationPath()))
        .environmentObject(previewViewModel)
}
