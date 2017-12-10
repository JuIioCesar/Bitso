//
//  URLSession + Bitso tasks.swift
//  Bitso-API
//
//  Created by Julio Cesar Guzman Villanueva on 12/3/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

extension URLComponents {
    
    enum Scheme: String {
        case secure = "https"
    }
    
    static var bitso: URLComponents {
        var components = URLComponents()
        components.scheme = URLComponents.Scheme.secure.rawValue
        components.host = "api-dev.bitso.com"
        return components
    }
}

extension URLSession {
    func decodeJSONTask<T: Decodable>(_ type: T.Type,
                                      from endpoint: Endpoint,
                                      completion: @escaping (T?, BitsoError?) -> () ) -> URLSessionTask {
        var components = URLComponents.bitso
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        let request = URLRequest(url: components.url!)
        let task = dataTask(with: request) { (data, _, _) in
            guard let data = data else {
                completion(nil, nil)
                return
            }
            let result = try? JSONDecoder().decode(type.self, from: data)
            let error = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            completion(result, error?.error)
        }
        return task
    }
}

protocol Endpoint {
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

struct AvailableBooksEndpoint: Endpoint {
    let path = "/v3/available_books"
    let queryItems: [URLQueryItem] = []
}

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

struct BitsoAPI {
    let session: URLSession
    
    func getAvailableBooksTask(completion: @escaping (BooksResponse?, BitsoError?) -> Void ) -> URLSessionTask {
        let endpoint = AvailableBooksEndpoint()
        return session.decodeJSONTask(BooksResponse.self, from: endpoint, completion: completion)
    }
    
    func bookInfoTask(with book: Book,
                      completion: @escaping (TickerResponse?, BitsoError?) -> Void) -> URLSessionTask {
        let endpoint = TickerEndpoint(book: book)
        return session.decodeJSONTask(TickerResponse.self, from: endpoint, completion: completion)
    }
    
    func orderBookTask(with book: Book,
                       aggregate: Bool,
                       completion: @escaping (OrderBookResponse?, BitsoError?) -> Void ) -> URLSessionTask {
        let endpoint = OrderBookEndpoint(book: book, aggregate: aggregate)
        return session.decodeJSONTask(OrderBookResponse.self, from: endpoint, completion: completion)
    }
    
    func tradesTask(with book: Book,
                    marker: String? = nil,
                    ascending: Bool,
                    limit: Int,
                    completion: @escaping (TradesResponse?, BitsoError?) -> Void ) -> URLSessionTask {
        let endpoint = TradesEndpoint(book: book, marker: marker, ascending: ascending, limit: limit)
        return session.decodeJSONTask(TradesResponse.self, from: endpoint, completion: completion)
    }
}

