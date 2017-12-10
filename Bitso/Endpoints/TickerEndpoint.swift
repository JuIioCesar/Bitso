//
//  Enpoint2.swift
//  Bitso
//
//  Created by Julio Cesar Guzman Villanueva on 12/10/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

struct TickerEndpoint: Endpoint {
    let path = "/v3/ticker"
    var queryItems: [URLQueryItem] {
        let bookQuery = URLQueryItem(name: "book", value: book.book)
        return [bookQuery]
    }
    private let book: Book
    init(book: Book) {
        self.book = book
    }
}
