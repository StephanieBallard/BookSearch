//
//  BookSearchViewModel.swift
//  BookSearch
//
//  Created by Stephanie Ballard on 10/15/26.
//

import Combine
import Foundation
import OSLog

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
    private let logger = Logger()

    init(bookService: BookServiceable? = nil) {
        self.bookService = bookService ?? BookService()
    }

    func fetchBooks(title: String) async {
        let title = title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !title.isEmpty else {
            loadingState = .idle
            return
        }

        guard await debounce() else { return }

        loadingState = .loading

        do {
            let books = try await bookService.fetchBooks(title: title)

            guard !Task.isCancelled else { return }

            loadingState = books.isEmpty ? .empty : .complete(books)
        } catch {
            guard !Task.isCancelled else { return }
            guard !(error is CancellationError) else { return }
            guard (error as? URLError)?.code != .cancelled else { return }

            logger.error("Book search failed: \(String(describing: error), privacy: .private)")
            loadingState = .error(error)
        }
    }

    private func debounce() async -> Bool {
        do {
            try await Task.sleep(for: .milliseconds(350))
            return !Task.isCancelled
        } catch {
            return false
        }
    }
}
