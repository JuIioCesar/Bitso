//
//  BitsoAPI+Public.swift
//  Bitso
//
//  Created by Julio Villanueva on 5/5/18.
//  Copyright © 2018 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

extension BitsoAPI {
    public func getAvailableBooksTask(success: @escaping (BooksResponse) -> Void,
                                      failure: @escaping (BitsoError?) -> Void ) -> URLSessionTask {
        let endpoint = AvailableBooksEndpoint()
        return session.decodeJSONTask(from: endpoint,
                                      success: success,
                                      failure: failure)
    }
    
    public func bookInfoTask(with book: Book,
                             success: @escaping (TickerResponse) -> Void,
                             failure: @escaping (BitsoError?) -> Void ) -> URLSessionTask {
        let endpoint = TickerEndpoint(book: book)
        return session.decodeJSONTask(from: endpoint,
                                      success: success,
                                      failure: failure)
    }
    
    public func orderBookTask(with book: Book,
                              aggregate: Bool,
                              success: @escaping (OrderBookResponse) -> Void,
                              failure: @escaping (BitsoError?) -> Void ) -> URLSessionTask {
        let endpoint = OrderBookEndpoint(book: book,
                                         aggregate: aggregate)
        return session.decodeJSONTask(from: endpoint,
                                      success: success,
                                      failure: failure)
    }
    
    public func tradesTask(with book: Book,
                           marker: String? = nil,
                           ascending: Bool,
                           limit: Int,
                           success: @escaping (TradesResponse) -> Void,
                           failure: @escaping (BitsoError?) -> Void ) -> URLSessionTask {
        let endpoint = TradesEndpoint(book: book,
                                      marker: marker,
                                      ascending: ascending,
                                      limit: limit)
        return session.decodeJSONTask(from: endpoint,
                                      success: success,
                                      failure: failure)
    }
}
