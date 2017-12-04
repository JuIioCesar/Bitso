//
//  URL + Bitso endpoints.swift
//  Bitso-API
//
//  Created by Julio Cesar Guzman Villanueva on 12/3/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

extension URL {
    static let BitsoDevelopment = "https://api.bitso.com/v3/"
    static let books = URL(string: URL.BitsoDevelopment + "available_books/")!
    static func bookInfo(book: Book) -> URL {
        return URL(string: URL.BitsoDevelopment + "ticker/?book=\(book.book!)")!
    }
    static func orderBook(book: Book, aggregate: Bool = false) -> URL {
        let aggregateString = aggregate ? "true": "false"
        return URL(string: URL.BitsoDevelopment + "order_book/?book=\(book.book!)&aggregate=\(aggregateString)")!
    }
    
    enum Sort: String {
        case ascending = "asc"
        case descending = "desc"
    }
    
    static func trades(book: Book, marker: String?, sort: Sort, limit: Int) -> URL {
        var string = URL.BitsoDevelopment + "trades?book=\(book.book!)"
        if let marker = marker {
            string = string + "&marker=\(marker)"
        }
        string = string + "&sort=\(sort.rawValue)"
        string = string + "&limit=\(limit)"
        return URL(string: string)!
    }
}
