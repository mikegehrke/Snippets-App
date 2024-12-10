import SwiftUI
import Firebase

@main
struct Code_SnippetsApp: App {
    @StateObject private var viewModel = AuthViewModel(authRepository: AuthRepository())

    init() {

        FirebaseApp.configure()

            FirebaseConfiguration.shared.setLoggerLevel(.min)
    }
    var body: some Scene {

        WindowGroup {
            AuthView()
        }
    }
}
