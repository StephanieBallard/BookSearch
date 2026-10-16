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

    init(bookService: BookServiceable? = nil) {
        self.bookService = bookService ?? BookService()
    }

    func fetchBooks(title: String) async {
        let title = title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !title.isEmpty else {
            loadingState = .idle
            return
        }

        do {
            try await Task.sleep(for: .milliseconds(350))
        } catch {
            return
        }

        guard !Task.isCancelled else { return }

        loadingState = .loading

        do {
            let books = try await bookService.fetchBooks(title: title)

            guard !Task.isCancelled else { return }

            loadingState = books.isEmpty ? .empty : .complete(books)
        } catch is CancellationError {
            return
        } catch {
            guard !Task.isCancelled else { return }

            loadingState = .error(error)
        }
    }
}
