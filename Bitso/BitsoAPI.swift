//
//  BitsoAPI.swift
//  Bitso
//
//  Created by Julio Cesar Guzman Villanueva on 12/10/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation


struct BitsoAPI {
    let session: URLSession
    
    public func getAvailableBooksTask(completion: @escaping (BooksResponse?, BitsoError?) -> Void ) -> URLSessionTask {
        let endpoint = AvailableBooksEndpoint()
        return session.decodeJSONTask(BooksResponse.self, from: endpoint, completion: completion)
    }
    
    public func bookInfoTask(with book: Book,
                      completion: @escaping (TickerResponse?, BitsoError?) -> Void) -> URLSessionTask {
        let endpoint = TickerEndpoint(book: book)
        return session.decodeJSONTask(TickerResponse.self, from: endpoint, completion: completion)
    }
    
    public func orderBookTask(with book: Book,
                       aggregate: Bool,
                       completion: @escaping (OrderBookResponse?, BitsoError?) -> Void ) -> URLSessionTask {
        let endpoint = OrderBookEndpoint(book: book, aggregate: aggregate)
        return session.decodeJSONTask(OrderBookResponse.self, from: endpoint, completion: completion)
    }
    
    public func tradesTask(with book: Book,
                    marker: String? = nil,
                    ascending: Bool,
                    limit: Int,
                    completion: @escaping (TradesResponse?, BitsoError?) -> Void ) -> URLSessionTask {
        let endpoint = TradesEndpoint(book: book, marker: marker, ascending: ascending, limit: limit)
        return session.decodeJSONTask(TradesResponse.self, from: endpoint, completion: completion)
    }
}
