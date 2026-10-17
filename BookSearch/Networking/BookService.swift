//
//  BookService.swift
//  BookSearch
//
//  Created by Stephanie Ballard on 10/15/26.
//

import Foundation

protocol BookServiceable {
    func fetchBooks(title: String) async throws -> [Book]
}

final class BookService: BookServiceable {
    private static let baseURL = "https://openlibrary.org/search.json"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchBooks(title: String) async throws -> [Book] {
        let title = title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !title.isEmpty else { return [] }

        let url = try createSearchURL(title: title)

        let (data, response) = try await session.data(from: url)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkingError.invalidResponse
        }

        guard (200..<300).contains(response.statusCode) else {
            throw NetworkingError.requestFailed(statusCode: response.statusCode)
        }

        return try JSONDecoder().decode(BookSearchResponse.self, from: data).docs
    }

    private func createSearchURL(title: String) throws -> URL {
        guard var components = URLComponents(string: BookService.baseURL) else {
            throw NetworkingError.invalidURL
        }

        components.queryItems = [URLQueryItem(name: "title", value: title),
                                 URLQueryItem(name: "limit", value: "10")]

        guard let url = components.url else {
            throw NetworkingError.invalidURL
        }

        return url
    }
}
