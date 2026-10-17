//
//  Book.swift
//  BookSearch
//
//  Created by Stephanie Ballard on 10/15/26.
//

struct BookSearchResponse: Decodable {
    let docs: [Book]
}

struct Book: Decodable, Identifiable {
    let id: String
    let title: String
    let authors: [String]?

    enum CodingKeys: String, CodingKey {
        case id = "key"
        case title
        case authors = "author_name"
    }
}
