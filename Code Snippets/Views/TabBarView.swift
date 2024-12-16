//
//  TabBarView.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 12.12.24.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var snippetViewModel: SnippetViewModel
    @EnvironmentObject var categoryViewModel: CategoryViewModel

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .environmentObject(userViewModel)
                .environmentObject(homeViewModel)

            PostView()
                .tabItem {
                    Label("Post", systemImage: "plus.circle")
                }
                .environmentObject(userViewModel)
                .environmentObject(homeViewModel)

            SnippetListView(category: Category(id: "1", name: "Beispiel-Kategorie", userId: "123", createdAt: Date()))
                .tabItem {
                    Label("Snippets", systemImage: "doc.text")
                }
                .environmentObject(snippetViewModel)

            CategoryView()
                .tabItem {
                    Label("Kategorien", systemImage: "folder")
                }
                .environmentObject(categoryViewModel)
        }
    }
}

#Preview {
    TabBarView()
        .environmentObject(UserViewModel())
        .environmentObject(HomeViewModel())
        .environmentObject(SnippetViewModel())
        .environmentObject(CategoryViewModel())
}
