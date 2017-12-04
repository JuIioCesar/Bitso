//
//  URLSession + Bitso tasks.swift
//  Bitso-API
//
//  Created by Julio Cesar Guzman Villanueva on 12/3/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation


internal extension URLSession {
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
