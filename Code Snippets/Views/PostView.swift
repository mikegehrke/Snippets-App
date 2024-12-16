//
//  PostView.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 12.12.24.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct PostView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var categoryViewModel: CategoryViewModel

    @State private var selectedCategoryId: String? = nil
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Neuen Post erstellen")
                .font(.largeTitle)
                .bold()

            // Eingabe für Titel
            TextField("Titel", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // Eingabe für Inhalt
            TextEditor(text: $content)
                .frame(height: 150)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal)

            // Kategorie-Auswahl
            Picker("Kategorie wählen", selection: $selectedCategoryId) {
                Text("Keine Kategorie").tag(nil as String?)
                ForEach(categoryViewModel.categories, id: \.id) { category in
                    Text(category.name).tag(category.id)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal)

            // Fehleranzeige
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }

            // Post erstellen Button
            Button(action: {
                Task {
                    await createPost()
                }
            }) {
                Text("Post erstellen")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(title.isEmpty || content.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(8)
            }
            .disabled(title.isEmpty || content.isEmpty)
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            if selectedCategoryId == nil && !categoryViewModel.categories.isEmpty {
                selectedCategoryId = categoryViewModel.categories.first?.id
            }
        }
    }

    // Post erstellen Funktion
    private func createPost() async {
        guard let user = userViewModel.user else {
            errorMessage = "Benutzer nicht gefunden."
            return
        }

        do {
            try await homeViewModel.createPost(
                title: title,
                content: content,
                author: user,
                categoryId: selectedCategoryId
            )
            // Eingaben zurücksetzen
            title = ""
            content = ""
            selectedCategoryId = nil
            errorMessage = nil
        } catch {
            errorMessage = "Fehler beim Erstellen des Posts: \(error.localizedDescription)"
        }
    }
}

#Preview {
    let previewCategoryViewModel = CategoryViewModel()
    previewCategoryViewModel.categories = [
        Category(id: "1", name: "Allgemein", userId: "123", createdAt: Date()),
        Category(id: "2", name: "Swift", userId: "123", createdAt: Date())
    ]

    return PostView()
        .environmentObject(HomeViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(previewCategoryViewModel)
}
