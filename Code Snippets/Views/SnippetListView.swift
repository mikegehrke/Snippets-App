//
//  SnippetListView.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 13.12.24.
//

// SnippetListView.swift
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SnippetListView: View {
    @EnvironmentObject var snippetViewModel: SnippetViewModel
    let category: Category

    @State private var title: String = ""
    @State private var code: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Snippet in Kategorie: \(category.name) erstellen")
                .font(.largeTitle)
                .bold()

            TextField("Snippet-Titel", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextEditor(text: $code)
                .frame(height: 100)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal)

            Button(action: {
                Task {
                    await snippetViewModel.addSnippet(title: title, code: code, categoryId: category.id)
                    title = ""
                    code = ""
                }
            }) {
                Text("Snippet hinzufügen")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(title.isEmpty || code.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(8)
            }
            .disabled(title.isEmpty || code.isEmpty)
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    SnippetListView (category: Category(id: "", name: "SwiftUI", userId: ""))
        .environmentObject(UserViewModel())
        .environmentObject(HomeViewModel())
        .environmentObject(SnippetViewModel())
        .environmentObject(CategoryViewModel())
}
