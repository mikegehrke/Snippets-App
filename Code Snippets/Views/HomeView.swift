//
//  SwiftUIView.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 09.12.24.
//
// HomeView.swift

import SwiftUI
import FirebaseFirestore

struct HomeView: View {
    @ObservedObject private var homeViewModel = HomeViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var snippetViewModel: SnippetViewModel
    @EnvironmentObject var categoryViewModel: CategoryViewModel

    @State private var showDeleteAlert = false
    @State private var postToDelete: Post?
    @State private var snippetToDelete: Snippet?
    @State private var selectedCategoryId: String? = nil

    var body: some View {
        VStack {
            let username = userViewModel.user?.name ?? "Guest"
            Text("Welcome, \(username)!")
                .font(.largeTitle)
                .padding()

            // Kategorie-Auswahl hinzufügen
            Picker("Kategorie wählen", selection: $selectedCategoryId) {
                ForEach(categoryViewModel.categories, id: \.id) { category in
                    Text(category.name).tag(category.id)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            if homeViewModel.posts.isEmpty && snippetViewModel.snippets.isEmpty {
                ProgressView("Laden...")
                    .onAppear {
                        Task {
                            await homeViewModel.fetchAllPosts()
                            await snippetViewModel.fetchAllSnippets()
                            await categoryViewModel.fetchCategories()
                        }
                    }
            } else {
                List {
                    ForEach(categoryViewModel.categories) { category in
                        Section(header: Text("Kategorie: \(category.name)")) {
                            ForEach(homeViewModel.posts.filter { $0.categoryId == category.id }) { post in
                                PostBubble(post: post, onDelete: { self.deletePost(post) })
                            }

                            ForEach(snippetViewModel.snippets.filter { $0.categoryId == category.id }) { snippet in
                                SnippetBubble(snippet: snippet, onDelete: { self.deleteSnippet(snippet) })
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Löschen bestätigen"),
                message: Text("Möchtest du dieses Element wirklich löschen?"),
                primaryButton: .destructive(Text("Löschen")) {
                    if let postToDelete = postToDelete {
                        Task {
                          try  await homeViewModel.deletePost(post: postToDelete)
                        }
                    } else if let snippetToDelete = snippetToDelete {
                        Task {
                         try   await snippetViewModel.deleteSnippet(snippet: snippetToDelete)
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func deletePost(_ post: Post) {
        self.postToDelete = post
        self.showDeleteAlert = true
    }

    private func deleteSnippet(_ snippet: Snippet) {
        self.snippetToDelete = snippet
        self.showDeleteAlert = true
    }
}

struct PostBubble: View {
    let post: Post
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(post.title)
                .font(.headline)
            Text(post.content)
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.1)))
        .swipeActions {
            Button(role: .destructive, action: onDelete) {
                Label("Löschen", systemImage: "trash")
            }
        }
    }
}

struct SnippetBubble: View {
    let snippet: Snippet
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(snippet.title)
                .font(.headline)
            Text(snippet.code)
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.1)))
        .swipeActions {
            Button(role: .destructive, action: onDelete) {
                Label("Löschen", systemImage: "trash")
            }
        }
    }
}

#Preview {
    let previewUserViewModel = UserViewModel()
    let previewHomeViewModel = HomeViewModel()
    let previewSnippetViewModel = SnippetViewModel()

    previewUserViewModel.user = FirestoreUser(
        id: "12345",
        email: "test@example.com",
        registeredOn: Date(),
        name: "Test User",
        birthDate: Date(),
        gender: "Männlich",
        occupation: "Entwickler"
    )

    previewHomeViewModel.posts = [
        Post(
            id: "1",
            author: "Test User",
            title: "Beispieltitel",
            content: "Das ist ein Beispielinhalt.",
            createdAt: Date(),
            updatedAt: Date(),
            likes: 10,
            categoryId: "1"
        )
    ]

    previewSnippetViewModel.snippets = [
        Snippet(
            id: "1",
            title: "Beispiel-Snippet",
            code: "print(\"Hello, World!\")",
            userId: "12345",
            categoryId: "1"
        )
    ]

    return HomeView()
        .environmentObject(previewUserViewModel)
        .environmentObject(previewHomeViewModel)
        .environmentObject(previewSnippetViewModel)
        .environmentObject(CategoryViewModel())
}
