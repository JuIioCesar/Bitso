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
}

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

extension BitsoAPI {
    func webSocket(with book: Book) {
//        let orders = SuscriptionMessage(action: "subscribe", book: book.book, type: "orders")
//        let diffOrders = SuscriptionMessage(action: "subscribe", book: book.book, type: "diff-orders")
        let trades = SuscriptionMessage(action: "subscribe", book: book.book, type: "trades")
        let socket = Socket<TradesChannelMessageResponse>(suscription: trades, completion: { element in
            element.payload.forEach({ (message) in
                print("$\(message.rate)MXN")
            })
        })
        socket.open()
    }
}
