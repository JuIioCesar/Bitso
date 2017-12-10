//
//  Endpoit3.swift
//  Bitso
//
//  Created by Julio Cesar Guzman Villanueva on 12/10/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

struct OrderBookEndpoint: Endpoint {
    let path = "/v3/order_book"
    var queryItems: [URLQueryItem] {
        let bookQuery = URLQueryItem(name: "book", value: book.book)
        let aggregateString = aggregate ? "true": "false"
        let aggregateQuery = URLQueryItem(name: "aggregate", value: aggregateString)
        return [bookQuery, aggregateQuery]
    }
    private let book: Book
    private let aggregate: Bool
    init(book: Book, aggregate: Bool) {
        self.book = book
        self.aggregate = aggregate
    }
}

