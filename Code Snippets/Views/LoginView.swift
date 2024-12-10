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

    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .bold()

            // E-Mail Eingabefeld
            TextField("E-Mail", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // Passwort Eingabefeld
            SecureField("Passwort", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // Login-Button
            Button(action: {
                Task {
                    await userViewModel.login(email: email, password: password)
                    if userViewModel.user != nil {
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

            // Anonym-Login-Button
            Button(action: {
                Task {
                    await userViewModel.loginAnonymously()
                    if userViewModel.user != nil {
                        path.append("HomeView")
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
