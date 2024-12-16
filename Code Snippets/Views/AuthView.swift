//
//  AuthView.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 10.12.24.
//

// AuthView.swift
import SwiftUI
import FirebaseAuth

struct AuthView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var snippetViewModel: SnippetViewModel
    @EnvironmentObject var categoryViewModel: CategoryViewModel

    var body: some View {
        NavigationStack(path: $userViewModel.path) {
            VStack {
                if userViewModel.isRegister {
                    RegisterView(path: $userViewModel.path)
                } else {
                    LoginView(path: $userViewModel.path)
                }
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "HomeView" {
                    TabBarView()
                        .environmentObject(userViewModel)
                        .environmentObject(homeViewModel)
                } else {
                    Text("Unbekanntes Ziel")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    let previewUserViewModel = UserViewModel()
    let previewHomeViewModel = HomeViewModel()
    let previewSnippetViewModel = SnippetViewModel()
    let previewCategoryViewModel = CategoryViewModel()

    AuthView()
        .environmentObject(previewUserViewModel)
        .environmentObject(previewHomeViewModel)
        .environmentObject(previewSnippetViewModel)
        .environmentObject(previewCategoryViewModel)

}
