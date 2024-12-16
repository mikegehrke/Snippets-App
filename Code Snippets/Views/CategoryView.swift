//
//  CategoryView.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 13.12.24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CategoryView: View {
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var snippetViewModel: SnippetViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    @State private var categoryName: String = ""
    @State private var isSaving: Bool = false
    @State private var navigateToPostView: Bool = false
    @State private var navigateToSnippetView: Bool = false
    @State private var selectedCategory: Category?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Kategorien")
                    .font(.largeTitle)
                    .bold()

                // Eingabe für Kategorien
                TextField("Kategorie-Name", text: $categoryName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    Task {
                        await addCategory()
                    }
                }) {
                    if isSaving {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Kategorie hinzufügen")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(categoryName.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(8)
                    }
                }
                .disabled(categoryName.isEmpty || isSaving)
                .padding(.horizontal)

                Divider().padding(.vertical)

                // Kategorienliste
                List(categoryViewModel.categories) { category in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(category.name)
                            .font(.headline)

                        HStack {
                            Button("Zu Posts") {
                                selectedCategory = category
                                navigateToPostView = true
                            }
                            .buttonStyle(.bordered)

                            Button("Zu Snippets") {
                                selectedCategory = category
                                navigateToSnippetView = true
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }

                NavigationLink(destination: PostView()
                                .environmentObject(homeViewModel), isActive: $navigateToPostView) { EmptyView() }

                NavigationLink(destination: SnippetListView(category: selectedCategory ?? Category(id: "", name: "", userId: "", createdAt: Date()))
                                .environmentObject(snippetViewModel), isActive: $navigateToSnippetView) { EmptyView() }
            }
            .onAppear {
                Task {
                    await categoryViewModel.fetchCategories()
                }
            }
            .padding()
        }
    }

    private func addCategory() async {
        isSaving = true
        await categoryViewModel.addCategory(name: categoryName)
        categoryName = ""
        isSaving = false
        await categoryViewModel.fetchCategories()
    }
}

#Preview {
    CategoryView()
        .environmentObject(CategoryViewModel())
        .environmentObject(HomeViewModel())
        .environmentObject(SnippetViewModel())
        .environmentObject(UserViewModel())
}
