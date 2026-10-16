//
//  Untitled.swift
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
    let author: [String]?

    enum CodingKeys: String, CodingKey {
        case id = "key"
        case title
        case author = "author_name"
    }
}
