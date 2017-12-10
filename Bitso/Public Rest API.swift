//
//  URLSession + Bitso tasks.swift
//  Bitso-API
//
//  Created by Julio Cesar Guzman Villanueva on 12/3/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

enum Strings {

    enum Public: String {
        case availableBooks = "available_books/"
        case ticker = "ticker/"
        case orderBook = "order_book/"
        case trades = "trades/"
    }
    
    enum Private: String {
        case accountStatus = "account_status/"
        case phoneNumber = "phone_number/"
        case phoneNumberVerification = "phone_verification/"
        case balance = "balance/"
        case fees = "fees/"
        case userTrades = "user_trades/"
        case openOrders = "open_orders"
        case placeOrder = "orders/"
        case fundingDestination = "funding_destination/"
        case bitcoinWithdrawal = "bitcoin_withdrawal/"
        case etherWithdrawal = "ether_withdrawal/"
        case speiWithdrawal = "spei_withdrawal/"
        case bankCodes = "mx_bank_codes/"
    }
}

private extension URL {
    
    enum Scheme: String {
        case secure = "https"
    }
    
    enum Enviroment: String {
        case development = "api-dev.bitso.com"
        case production = "api.bitso.com"
    }
    
    static func bitsoComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = URL.Scheme.secure.rawValue
        components.host = URL.Enviroment.development.rawValue
        return components
    }
}

extension URLSession {
    func decodeJSONTask<T: Decodable>(_ type: T.Type, from url: URL, completion: @escaping (T?, BitsoError?) -> () ) -> URLSessionTask {
        let request = URLRequest(url: url)
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


extension URLSession {
    func getAvailableBooksTask(completion: @escaping (BooksResponse?, BitsoError?) -> Void ) -> URLSessionTask {
        var components = URL.bitsoComponents()
        let endpoint = AvailableBooksEndpoint()
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        return decodeJSONTask(BooksResponse.self, from: components.url!, completion: completion)
    }

    func bookInfoTask(with book: Book,
                      completion: @escaping (TickerResponse?, BitsoError?) -> Void) -> URLSessionTask {
        var components = URL.bitsoComponents()
        let endpoint = TickerEndpoint(book: book)
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        return decodeJSONTask(TickerResponse.self, from: components.url!, completion: completion)
    }

    func orderBookTask(with book: Book,
                       aggregate: Bool,
                       completion: @escaping (OrderBookResponse?, BitsoError?) -> Void ) -> URLSessionTask {
        var components = URL.bitsoComponents()
        let endpoint = OrderBookEndpoint(book: book, aggregate: aggregate)
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        return decodeJSONTask(OrderBookResponse.self, from: components.url!, completion: completion)
    }

    func tradesTask(with book: Book,
                    marker: String? = nil,
                    ascending: Bool,
                    limit: Int = 100,
                    completion: @escaping (TradesResponse?, BitsoError?) -> Void ) -> URLSessionTask {
        var components = URL.bitsoComponents()
        let endpoint = TradesEndpoint(book: book, marker: marker, ascending: ascending, limit: limit)
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        return decodeJSONTask(TradesResponse.self, from: components.url!, completion: completion)
    }
}
