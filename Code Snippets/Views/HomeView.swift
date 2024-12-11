//
//  SwiftUIView.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 09.12.24.
//
import SwiftUI
import Firebase
import FirebaseAuth

// MARK: - Home View
struct HomeView: View {
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Lookout!")
                .font(.largeTitle)
                .padding()

            Text("Hier können Sie Orte auswählen und Ihre nächste Reise planen.")
                .multilineTextAlignment(.center)
                .padding()

            Button(action: {
                print("Ort auswählen gedrückt!")
            }) {
                Text("Ort auswählen")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)

            Button(action: {
                Task {
                    do {
                        try await userViewModel.logout()
                        userViewModel.path = NavigationPath() // Navigation zurücksetzen
                    } catch {
                        userViewModel.errorMessage = "Logout fehlgeschlagen: \(error.localizedDescription)"
                    }
                }
            }) {
                Text("Logout")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)

            if let errorMessage = userViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
    }
}

#Preview {
    let previewViewModel = UserViewModel()
    HomeView()
        .environmentObject(previewViewModel)
}
