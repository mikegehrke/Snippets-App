import SwiftUI
import Firebase
import FirebaseAuth

@main
struct Code_SnippetsApp: App {
    @StateObject private var userViewModel = UserViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AuthView()
                .environmentObject(userViewModel)
        }
    }
}
