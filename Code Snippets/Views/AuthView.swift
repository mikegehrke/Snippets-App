//
//  AuthView.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 10.12.24.
//
import SwiftUI
import FirebaseAuth

struct AuthView: View {
    @ObservedObject private var viewModel = AuthViewModel(authRepository: AuthRepository())
    @State private var email = ""
    @State private var password = ""
    @State private var path: [String] = [] // Navigation-Pfad für NavigationStack

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                // TextField für die E-Mail
                TextField("Bitte geben Sie Ihre E-Mail ein", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // SecureField für das Passwort
                SecureField("Bitte geben Sie Ihr Passwort ein", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Button für den Login
                Button(action: {
                    Task {
                        await viewModel.login(email: email, password: password)
                        if viewModel.user != nil {
                            path.append("HomeView")
                        }
                    }
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)

                // Button für anonymen Login
                Button(action: {
                    Task {
                        await viewModel.loginAnonymously()
                        if viewModel.user != nil {
                            path.append("HomeView")
                        }
                    }
                }) {
                    Text("Login Anonymously")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)

                // Button für die Registrierung
                Button(action: {
                    Task {
                        await viewModel.register(email: email, password: password)
                        if viewModel.user != nil {
                            path.append("HomeView")
                        }
                    }
                }) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.orange)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)

                // Anzeige des Status
                if let user = viewModel.user {
                    Text("Logged in as: \(user.uid)")
                        .padding()
                        .foregroundColor(.green)
                } else {
                    Text("Not logged in")
                        .padding()
                        .foregroundColor(.red)
                }
            }
            .padding()
            .navigationTitle("Authentication")
            .navigationDestination(for: String.self) { destination in
                if destination == "HomeView" {
                    HomeView()
                }
            }
        }
    }
}

#Preview {
    AuthView()
}
