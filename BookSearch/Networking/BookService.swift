//
//  Untitled.swift
//  BookSearch
//
//  Created by Stephanie Ballard on 10/15/26.
//

import Foundation

protocol BookServiceable {
    func fetchBooks(title: String) async throws -> [Book]
}

enum NetworkingError: Error {
    case incorrectURL
    case requestFailed
}

final class BookService: BookServiceable {
    let baseURL = "https://openlibrary.org/search.json"

    func fetchBooks(title: String) async throws -> [Book] {
        guard var components = URLComponents(string: baseURL) else {
            throw NetworkingError.incorrectURL
        }

        components.queryItems = [URLQueryItem(name: "title", value: title),
                                 URLQueryItem(name: "limit", value: "10")]

        guard let url = components.url else {
            throw NetworkingError.incorrectURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkingError.requestFailed
        }

        let results = try JSONDecoder().decode(BookSearchResponse.self, from: data)

        return results.docs
    }
}
