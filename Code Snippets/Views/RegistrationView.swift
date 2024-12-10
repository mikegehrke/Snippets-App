//
//  RegistrationView.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 10.12.24.
//

import SwiftUI
import FirebaseAuth

struct RegistrationView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            TextField("E-Mail", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("Passwort", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                Task {
                    await viewModel.register(email: email, password: password)
                    dismiss()
                }
            }) {
                Text("Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    RegistrationView(viewModel: AuthViewModel(authRepository: AuthRepository()))
}
