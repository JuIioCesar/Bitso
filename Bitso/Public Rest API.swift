//
//  URLSession + Bitso tasks.swift
//  Bitso-API
//
//  Created by Julio Cesar Guzman Villanueva on 12/3/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

private extension URL {
    static let BitsoDevelopment = "https://api.bitso.com/v3/"
}

extension URL {
    static let books = URL(string: URL.BitsoDevelopment + "available_books/")!
}

extension URLSession {
    func booksTask(completion: @escaping (BooksResponse?) -> Void ) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: URL.books) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            let books = try? JSONDecoder().decode(BooksResponse.self, from: data)
            completion(books)
        }
        return task
    }
}

extension URL {
    static func bookInfo(book: Book) -> URL {
        return URL(string: URL.BitsoDevelopment + "ticker/?book=\(book.book)")!
    }
}

extension URLSession {
    func bookInfoTask(with book: (Book), completion: @escaping (TickerResponse?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: URL.bookInfo(book: book),
                                              completionHandler: { (data, response, error) in
                                                guard let data = data else {
                                                    completion(nil)
                                                    return
                                                }
                                                let ticker = try? JSONDecoder().decode(TickerResponse.self, from: data)
                                                completion(ticker)
        })
        return task
    }
}

extension URL {
    static func orderBook(book: Book, aggregate: Bool = false) -> URL {
        let aggregateString = aggregate ? "true": "false"
        return URL(string: URL.BitsoDevelopment + "order_book/?book=\(book.book)&aggregate=\(aggregateString)")!
    }
}

extension URLSession {
    func orderBookTask(with book: (Book), aggregate: Bool, completion: @escaping (OrderBookResponse?) -> Void ) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: URL.orderBook(book: book, aggregate: aggregate),
                                              completionHandler: { (data, response, error) in
                                                guard let data = data else {
                                                    completion(nil)
                                                    return
                                                }
                                                let ticker = try? JSONDecoder().decode(OrderBookResponse.self, from: data)
                                                completion(ticker)
        })
        return task
    }
}

extension URL {
    enum Sort: String {
        case ascending = "asc"
        case descending = "desc"
    }
    
    static func trades(book: Book, marker: String?, sort: Sort, limit: Int) -> URL {
        var string = URL.BitsoDevelopment + "trades?book=\(book.book)"
        if let marker = marker {
            string = string + "&marker=\(marker)"
        }
        string = string + "&sort=\(sort.rawValue)"
        string = string + "&limit=\(limit)"
        return URL(string: string)!
    }
}

extension URLSession {
    func tradesTask(with book: (Book), marker: String? = nil, sort: URL.Sort = URL.Sort.ascending, limit: Int = 100, completion: @escaping (TradesResponse?) -> Void ) -> URLSessionDataTask {
        let task = dataTask(with: URL.trades(book: book,
                                             marker: marker,
                                             sort: URL.Sort.descending,
                                             limit: limit),
                            completionHandler: { (data, response, error) in
                                guard let data = data else {
                                    completion(nil)
                                    return
                                }
                                let result = try? JSONDecoder().decode(TradesResponse.self, from: data)
                                completion(result)
        })
        return task
    }
}
