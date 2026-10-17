//
//  BookSearchView.swift
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
                .accessibilityLabel("Loading books")

        case .empty:
            ContentUnavailableView.search(text: searchString)

        case .error:
            ContentUnavailableView("Something went wrong.",
                                   systemImage: "exclamationmark.triangle",
                                   description: Text("Unable to load books. Try a different search."))

        case .complete(let books):
            List(books) { book in
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.title)

                    if let authors = book.authors, !authors.isEmpty {
                        Text("Written by: \(authors.joined(separator: ", "))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .accessibilityElement(children: .combine)
            }
        }
    }
}

#Preview {
    BookSearchView()
}
