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

    var body: some View {
        VStack(spacing: 20) {
            Text("Registrieren")
                .font(.largeTitle)
                .bold()

            TextField("E-Mail", text: $userViewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("Passwort", text: $userViewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                Task {
                    await userViewModel.register(email: userViewModel.email, password: userViewModel.password)
                    if userViewModel.user != nil {
                        path.append("HomeView")
                    }
                }
            }) {
                Text("Registrieren")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.orange)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)

            Button(action: {
                userViewModel.isRegister = false
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
