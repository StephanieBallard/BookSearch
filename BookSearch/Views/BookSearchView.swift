//
//  ContentView.swift
//  BookSearch
//
//  Created by Stephanie Ballard on 10/15/26.
//

import SwiftUI

struct BookSearchView: View {
    @StateObject private var bookViewModel = BookSearchViewModel()
    @State private var searchString = ""

    var body: some View {
        NavigationStack {
            searchContent
                .navigationTitle("Book Search")
                .searchable(text: $searchString,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: "Enter a book title")
                .task(id: searchString) {
                    await bookViewModel.fetchBooks(title: searchString)
                }
        }
    }

    @ViewBuilder
    private var searchContent: some View {
        switch bookViewModel.loadingState {
        case .idle:
            ContentUnavailableView.search

        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .empty:
            ContentUnavailableView.search(text: searchString)

        case .error(let error):
            ContentUnavailableView("Something went wrong. Please retry your search.",
                                   systemImage: "exclamationmark.triangle",
                                   description: Text(error.localizedDescription))

        case .complete(let books):
            List(books) { book in
                VStack(alignment: .leading, spacing: 4) {
                    Text("Title: \(book.title)")

                    if let authors = book.author, !authors.isEmpty {
                        Text("Written by: \(authors.joined(separator: ", "))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    BookSearchView()
}
