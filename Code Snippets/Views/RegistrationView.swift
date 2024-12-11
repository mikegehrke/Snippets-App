//
//  RegistrationView.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 10.12.24.
//
import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Binding var path: NavigationPath
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var birthDate: Date = Date()
    @State private var gender: String = ""
    @State private var occupation: String = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Registrieren")
                .font(.largeTitle)
                .bold()

            // Eingabefelder
            TextField("E-Mail", text: $email)
                .textFieldStyle(.roundedBorder)
            SecureField("Passwort", text: $password)
                .textFieldStyle(.roundedBorder)
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
            DatePicker("Geburtsdatum", selection: $birthDate, displayedComponents: .date)
            TextField("Geschlecht", text: $gender)
                .textFieldStyle(.roundedBorder)
            TextField("Beruf", text: $occupation)
                .textFieldStyle(.roundedBorder)

            // Fehlermeldung
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            // Registrierung-Button
            Button("Registrieren") {
                Task {
                    do {
                        try await userViewModel.register(
                            email: email,
                            password: password,
                            name: name,
                            birthDate: birthDate,
                            gender: gender,
                            occupation: occupation
                        )
                        path.append("HomeView")
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(email.isValidEmail && password.isValidPassword ? Color.blue : Color.gray)
            .cornerRadius(8)
            .disabled(email.isEmpty || password.isEmpty)

            // Zurück zum Login
            Button(action: {
                userViewModel.switchToLogin()
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
