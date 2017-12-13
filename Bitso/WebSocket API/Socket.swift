//
//  Socket.swift
//  Bitso
//
//  Created by Julio Cesar Guzman Villanueva on 12/13/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation
import SwiftWebSocket

//TODO: Find a better way to do this:
private extension SuscriptionMessage {
    var json: String {
        let suscriptionData = try! JSONEncoder().encode(self)
        let json = String(data: suscriptionData, encoding: String.Encoding.utf8)!
        return json
    }
}

struct Socket<ResponseType: Codable> {
    private let socket = WebSocket("wss://ws.bitso.com")
    private let suscription: SuscriptionMessage
    private let completion: (ResponseType) -> Void
    init(suscription: SuscriptionMessage, completion: @escaping (ResponseType) -> Void) {
        self.suscription = suscription
        self.completion = completion
        setEvents()
    }
    
    func open() {
        socket.open()
    }
    
    private func setEvents() {
        socket.event.open = {
            self.socket.send(text: self.suscription.json)
        }
        socket.event.close = { code, reason, clean in
            print("close")
        }
        socket.event.error = { error in
            print("error \(error)")
        }
        socket.event.message = { message in
            if let text = message as? String,
                let data = text.data(using: .utf8),
                let result = try? JSONDecoder().decode(ResponseType.self, from: data) {
                self.completion(result)
            }
        }
    }
}
