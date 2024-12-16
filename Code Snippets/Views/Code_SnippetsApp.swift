import SwiftUI
import Firebase

@main
struct Code_SnippetsApp: App {
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject var snippetViewModel = SnippetViewModel()
    @StateObject var categoryViewModel = CategoryViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AuthView()
                .environmentObject(userViewModel)
                .environmentObject(homeViewModel)
        }
    }
}
