//
//  NetworkingError.swift
//  BookSearch
//
//  Created by Stephanie Ballard on 10/16/26.
//

import Foundation

enum NetworkingError: LocalizedError {
    case invalidURL
    case invalidResponse
    case requestFailed(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Unable to create the search URL."

        case .invalidResponse:
            return "Invalid server response"

        case .requestFailed(let statusCode):
            return "The request failed with status code \(statusCode)."
        }
    }
}
