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
        case development = "api.bitso.com/v3/"
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
    
    enum Components: String {
        case book = "book"
        case aggregate = "aggregate"
        enum Aggregate: String {
            case `true` = "true"
            case `false` = "false"
            
            init(value: Bool) {
                self = value ? Aggregate.true : Aggregate.false
            }
        }
        
        case marker = "marker"
        case sort = "sort"
        enum Sort: String {
            case ascending = "asc"
            case descending = "desc"
            
            init(ascending: Bool) {
                self = ascending ? Sort.ascending : Sort.descending
            }
        }
        case limit = "limit"
    }
    
    
}

extension URL {
    static let books = URL(string: "https://" + Endpoint.Enviroment.development.rawValue + Endpoint.Public.availableBooks.rawValue)!
}

extension URL {
    static func info(from book: Book) -> URL {
        var components = URLComponents()
        components.scheme = Endpoint.Scheme.secure.rawValue;
        components.host = Endpoint.Enviroment.development.rawValue;
        components.path = Endpoint.Public.ticker.rawValue;
        let bookComponent = URLQueryItem(name: Endpoint.Components.book.rawValue, value: book.book)
        components.queryItems = [bookComponent]
        return components.url!
    }
}

extension URL {
    static func orderBook(book: Book,
                          aggregate: Bool = false) -> URL {
        var components = URLComponents()
        components.scheme = Endpoint.Scheme.secure.rawValue;
        components.host = Endpoint.Enviroment.development.rawValue;
        components.path =  Endpoint.Public.orderBook.rawValue;
        let bookComponent = URLQueryItem(name: Endpoint.Components.book.rawValue,
                                         value: book.book)
        let aggregateComponent = URLQueryItem(name: Endpoint.Components.aggregate.rawValue,
                                              value: Endpoint.Components.Aggregate(value: aggregate).rawValue)
        components.queryItems = [bookComponent, aggregateComponent]
        return components.url!
    }
}

extension URL {
    static func trades(book: Book,
                       marker: String?,
                       ascending: Bool,
                       limit: Int) -> URL {
        var components = URLComponents()
        components.scheme = Endpoint.Scheme.secure.rawValue;
        components.host = Endpoint.Enviroment.development.rawValue;
        components.path =  Endpoint.Public.trades.rawValue;
        var items = [URLQueryItem]()
        let bookComponent = URLQueryItem(name: Endpoint.Components.book.rawValue,
                                         value: book.book)
        items.append(bookComponent)
        if let marker = marker {
            let markerComponent = URLQueryItem(name: Endpoint.Components.marker.rawValue,
                                               value: marker)
            items.append(markerComponent)
        }
        let sortComponent = URLQueryItem(name: Endpoint.Components.sort.rawValue,
                                         value: Endpoint.Components.Sort(ascending: ascending).rawValue)
        let limitComponent = URLQueryItem(name: Endpoint.Components.limit.rawValue,
                                           value: "\(limit)")
        items.append(contentsOf: [sortComponent, limitComponent])
        components.queryItems = items
        return components.url!
    }
}

extension URLSession {
    func decode<T: Decodable>(_ type: T.Type,
                              from url: URL,
                              completion: @escaping (T?) -> () ) -> URLSessionTask {
        let task = dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            let result = try? JSONDecoder().decode(type.self, from: data)
            completion(result)
        }
        return task
    }
}

extension URLSession {
    func booksTask(completion: @escaping (BooksResponse?) -> Void ) -> URLSessionTask {
        return decode(BooksResponse.self,
                      from: URL.books,
                      completion: completion)
    }
}

extension URLSession {
    func bookInfoTask(with book: (Book),
                      completion: @escaping (TickerResponse?) -> Void) -> URLSessionTask {
        let url = URL.info(from: book)
        return decode(TickerResponse.self,
                      from: url,
                      completion: completion)
    }
}


extension URLSession {
    func orderBookTask(with book: (Book),
                       aggregate: Bool,
                       completion: @escaping (OrderBookResponse?) -> Void ) -> URLSessionTask {
        let url =  URL.orderBook(book: book, aggregate: aggregate)
        return decode(OrderBookResponse.self,
                      from: url,
                      completion: completion)
    }
}

extension URLSession {
    func tradesTask(with book: (Book),
                    marker: String? = nil,
                    ascending: Bool,
                    limit: Int = 100,
                    completion: @escaping (TradesResponse?) -> Void ) -> URLSessionTask {
        let url = URL.trades(book: book,
                             marker: marker,
                             ascending: ascending,
                             limit: limit)
        return decode(TradesResponse.self,
                      from: url,
                      completion: completion)
    }
}
