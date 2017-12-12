//
//  BitsoAPI.swift
//  Bitso
//
//  Created by Julio Cesar Guzman Villanueva on 12/10/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation
import SwiftWebSocket

struct BitsoAPI {
    let session: URLSession
}

extension BitsoAPI {
    public func getAvailableBooksTask(completion: @escaping (BooksResponse?, BitsoError?) -> Void ) -> URLSessionTask {
        let endpoint = AvailableBooksEndpoint()
        return session.decodeJSONTask(from: endpoint, completion: completion)
    }
    
    public func bookInfoTask(with book: Book,
                      completion: @escaping (TickerResponse?, BitsoError?) -> Void) -> URLSessionTask {
        let endpoint = TickerEndpoint(book: book)
        return session.decodeJSONTask(from: endpoint, completion: completion)
    }
    
    public func orderBookTask(with book: Book,
                       aggregate: Bool,
                       completion: @escaping (OrderBookResponse?, BitsoError?) -> Void ) -> URLSessionTask {
        let endpoint = OrderBookEndpoint(book: book, aggregate: aggregate)
        return session.decodeJSONTask(from: endpoint, completion: completion)
    }
    
    public func tradesTask(with book: Book,
                    marker: String? = nil,
                    ascending: Bool,
                    limit: Int,
                    completion: @escaping (TradesResponse?, BitsoError?) -> Void ) -> URLSessionTask {
        let endpoint = TradesEndpoint(book: book, marker: marker, ascending: ascending, limit: limit)
        return session.decodeJSONTask(from: endpoint, completion: completion)
    }

}

extension BitsoAPI {
    func echoTest() {
        //TODO: make a wrapper here...
        let socket = WebSocket("wss://ws.bitso.com")
        socket.event.open = {
            let suscription = ClientSuscriptionMessage(action: "subscribe", book: "btc_mxn", type: "diff-orders") //trades
            let suscriptionData = try! JSONEncoder().encode(suscription)
            let json = String(data: suscriptionData, encoding: String.Encoding.utf8)!
            socket.send(text:json)
        }
        socket.event.close = { code, reason, clean in
            print("close")
        }
        socket.event.error = { error in
            print("error \(error)")
        }
        socket.event.message = { message in
            if let text = message as? String,
                let data = text.data(using: .utf8) {
                
               if let result = try? JSONDecoder().decode(TradesChannelMessageResponse.self, from: data) {
                    result.payload.forEach({ (message) in
                        print("\(result.type + "amount" + message.a + "rate:" + message.r + "value:" + message.v)")
                    })
                }
                
                print(text)
                if let result = try? JSONDecoder().decode(DiffOrdersChannelMessageResponse.self, from: data) {
                    result.payload.forEach({ (message) in
                        print("\(message.o)")
                    })
                }
                
            }
            
        }
    }
}
