//
//  AuthView.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 10.12.24.
//

import SwiftUI
import FirebaseAuth

struct AuthView: View {
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        NavigationStack(path: $userViewModel.path) { // Pfad ist NavigationPath
            VStack {
                if userViewModel.isRegister {
                    RegisterView(path: $userViewModel.path)
                } else {
                    LoginView(path: $userViewModel.path)
                }
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "HomeView" {
                    HomeView()
                } else {
                    Text("Unbekanntes Ziel")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    let previewViewModel = UserViewModel()
    AuthView()
        .environmentObject(previewViewModel)
}
