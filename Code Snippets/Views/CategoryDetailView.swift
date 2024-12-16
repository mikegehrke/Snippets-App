//
//  CategoryDetailView.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 13.12.24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CategoryDetailView: View {
    let category: Category
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var snippetViewModel: SnippetViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var categoryViewModel: CategoryViewModel

    var body: some View {
        VStack {
            Text("Kategorie: \(category.name)")
                .font(.largeTitle)
                .bold()
                .padding()

            List {
                Section(header: Text("Posts")) {
                    ForEach(homeViewModel.posts.filter { $0.categoryId == category.id }) { post in
                        VStack(alignment: .leading) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.content)
                                .font(.subheadline)
                        }
                    }
                }

                Section(header: Text("Snippets")) {
                    ForEach(snippetViewModel.snippets.filter { $0.categoryId == category.id }) { snippet in
                        VStack(alignment: .leading) {
                            Text(snippet.title)
                                .font(.headline)
                            Text(snippet.code)
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await homeViewModel.fetchAllPosts()
                await snippetViewModel.fetchAllSnippets()
            }
        }
    }
}

#Preview {
    CategoryDetailView(category: Category(id: "1", name: "Beispiel-Kategorie", userId: "123", createdAt: Date()))
        .environmentObject(HomeViewModel())
        .environmentObject(SnippetViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(CategoryViewModel())
}
