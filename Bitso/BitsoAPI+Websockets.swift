//
//  BitsoAPI+Websockets.swift
//  Bitso
//
//  Created by Julio Villanueva on 5/5/18.
//  Copyright © 2018 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

extension BitsoAPI {
    public func tradesStream(with book: Book,
                             success: @escaping (TradesChannelMessageResponse) -> Void,
                             failure: @escaping (Error) -> Void,
                             close: @escaping (Int, String, Bool) -> Void) {
        let trades = SuscriptionMessage(book: book.book, type: SuscriptionMessageType.trades.rawValue)
        let socket = Socket<TradesChannelMessageResponse>(suscription: trades,
                                                          completion: success,
                                                          failure: failure,
                                                          close: close)
        socket.open()
    }
    
    public func ordersStream(with book: Book,
                             success: @escaping (OrdersChannelMessageResponse) -> Void,
                             failure: @escaping (Error) -> Void,
                             close: @escaping (Int, String, Bool) -> Void) {
        let trades = SuscriptionMessage(book: book.book, type: SuscriptionMessageType.orders.rawValue)
        let socket = Socket<OrdersChannelMessageResponse>(suscription: trades,
                                                          completion: success,
                                                          failure: failure,
                                                          close: close)
        socket.open()
    }

    public func diffOrdersStream(with book: Book,
                             success: @escaping (DiffOrdersChannelMessageResponse) -> Void,
                             failure: @escaping (Error) -> Void,
                             close: @escaping (Int, String, Bool) -> Void) {
        let trades = SuscriptionMessage(book: book.book, type: SuscriptionMessageType.diffOrders.rawValue)
        let socket = Socket<DiffOrdersChannelMessageResponse>(suscription: trades,
                                                              completion: success,
                                                              failure: failure,
                                                              close: close)
        socket.open()
    }
}
