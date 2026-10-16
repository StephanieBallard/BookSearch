//
//  BookSearchViewModel.swift
//  BookSearch
//
//  Created by Stephanie Ballard on 10/15/26.
//

import Combine
import Foundation

@MainActor
final class BookSearchViewModel: ObservableObject {
    enum ContentLoadingState {
        case idle
        case loading
        case empty
        case error(Error)
        case complete([Book])
    }

    @Published private(set) var loadingState: ContentLoadingState = .idle

    private let bookService: BookServiceable
    private var fetchTask: Task<Void, Never>?

    init(bookService: BookServiceable? = nil) {
        self.bookService = bookService ?? BookService()
    }

    func fetchBooks(title: String) {
        let query = title.trimmingCharacters(in: .whitespacesAndNewlines)

        fetchTask?.cancel()

        guard !query.isEmpty else {
            loadingState = .idle
            return
        }

        loadingState = .loading

        fetchTask = Task {
            do {
                let books = try await bookService.fetchBooks(title: query)

                guard !Task.isCancelled else { return }

                loadingState = books.isEmpty ? .empty : .complete(books)
            } catch {
                guard !Task.isCancelled else { return }

                loadingState = .error(error)
            }
        }
    }
}
