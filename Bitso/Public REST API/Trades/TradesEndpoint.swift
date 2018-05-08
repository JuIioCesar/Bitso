//
//  Endpoint4.swift
//  Bitso
//
//  Created by Julio Cesar Guzman Villanueva on 12/10/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

struct TradesEndpoint: Endpoint {
    let path = "/v3/trades"
    var queryItems: [URLQueryItem] {
        let bookQuery = URLQueryItem(name: "book", value: book.book)
        let markerQuery = URLQueryItem(name: "marker", value: marker)
        let sort = ascending ? "asc" : "desc"
        let sortQuery = URLQueryItem(name: "sort", value: sort)
        let limitQuery = URLQueryItem(name: "limit", value: "\(limit)")
        return [bookQuery, markerQuery, sortQuery, limitQuery]
    }
    private let book: Book
    private let marker: String?
    private let ascending: Bool
    private let limit: Int
    init(book: Book, marker: String? = nil, ascending: Bool, limit: Int = 100) {
        self.book = book
        self.marker = marker
        self.ascending = ascending
        self.limit = limit
    }
}
