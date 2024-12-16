//
//  SettingsView.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 12.12.24.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Einstellungen")
                .font(.largeTitle)
                .bold()

            // Button: Eigene Posts anzeigen
            Button(action: {
                Task {
                    await homeViewModel.fetchPostsByUser(userId: userViewModel.user?.id ?? "")
                }
            }) {
                Text("Eigene Posts anzeigen")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            // Button: Eigene Posts löschen
            Button(action: {
                Task {
                    do {
                        for post in homeViewModel.userPosts {
                            try await homeViewModel.deletePost(post: post)
                        }
                    } catch {
                        errorMessage = "Fehler beim Löschen der Posts: \(error.localizedDescription)"
                    }
                }
            }) {
                Text("Eigene Posts löschen")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(8)
            }

            // Button: Logout
            Button(action: {
                Task {
                    do {
                        try await userViewModel.logout()
                    } catch {
                        errorMessage = "Fehler beim Logout: \(error.localizedDescription)"
                    }
                }
            }) {
                Text("Logout")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(8)
            }

            // Fehlermeldungen anzeigen
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
    }
}

#Preview {
    let previewUserViewModel = UserViewModel()
    let previewHomeViewModel = HomeViewModel()

    return SettingsView()
        .environmentObject(previewUserViewModel)
        .environmentObject(previewHomeViewModel)
}
