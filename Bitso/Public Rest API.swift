//
//  URLSession + Bitso tasks.swift
//  Bitso-API
//
//  Created by Julio Cesar Guzman Villanueva on 12/3/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

enum Endpoint {
    enum Scheme: String {
        case secure = "https"
    }
    
    enum Enviroment: String {
        case development = "api-dev.bitso.com/v3/"
        case production = "api.bitso.com/v3/"
    }
    
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

extension URLSession {
    func decodeJSONTask<T: Decodable>(_ type: T.Type, from request: URLRequest, completion: @escaping (T?, BitsoError?) -> () ) -> URLSessionTask {
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

private extension URL {
    static func bitsoComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api-dev.bitso.com"
        return components
    }
}

extension URLSession {
    func getAvailableBooksTask(completion: @escaping (BooksResponse?, BitsoError?) -> Void ) -> URLSessionTask {
        var components = URL.bitsoComponents()
        components.path = "/v3/available_books"
        let request = URLRequest(url: components.url!)
        return decodeJSONTask(BooksResponse.self, from: request, completion: completion)
    }

    func bookInfoTask(with book: Book,
                      completion: @escaping (TickerResponse?, BitsoError?) -> Void) -> URLSessionTask {
        var components = URL.bitsoComponents()
        components.path = "/v3/ticker"
        let bookQuery = URLQueryItem(name: "book", value: book.book)
        components.queryItems = [bookQuery]
        let request = URLRequest(url: components.url!)
        return decodeJSONTask(TickerResponse.self, from: request, completion: completion)
    }

    func orderBookTask(with book: Book,
                       aggregate: Bool,
                       completion: @escaping (OrderBookResponse?, BitsoError?) -> Void ) -> URLSessionTask {
        var components = URL.bitsoComponents()
        components.path = "/v3/order_book"
        let bookQuery = URLQueryItem(name: "book", value: book.book)
        let aggregateString = aggregate ? "true": "false"
        let aggregateQuery = URLQueryItem(name: "aggregate", value: aggregateString)
        components.queryItems = [bookQuery, aggregateQuery]
        let request = URLRequest(url: components.url!)
        return decodeJSONTask(OrderBookResponse.self, from: request, completion: completion)
    }

    func tradesTask(with book: Book,
                    marker: String? = nil,
                    ascending: Bool,
                    limit: Int = 100,
                    completion: @escaping (TradesResponse?, BitsoError?) -> Void ) -> URLSessionTask {
        var components = URL.bitsoComponents()
        components.path = "/v3/trades"
        let bookQuery = URLQueryItem(name: "book", value: book.book)
        let markerQuery = URLQueryItem(name: "marker", value: marker)
        let sort = ascending ? "asc" : "desc"
        let sortQuery = URLQueryItem(name: "sort", value: sort)
        let limitQuery = URLQueryItem(name: "limit", value: "\(limit)")
        components.queryItems = [bookQuery, markerQuery, sortQuery, limitQuery]
        let request = URLRequest(url: components.url!)
        return decodeJSONTask(TradesResponse.self, from: request, completion: completion)
    }
}
