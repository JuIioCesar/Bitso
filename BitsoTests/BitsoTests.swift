//
//  BitsoTests.swift
//  BitsoTests
//
//  Created by Julio Cesar Guzman Villanueva on 12/3/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import XCTest
@testable import Bitso

func print(_ error: BitsoError?) {
    if let error = error { print("🔴 Error: \(error.code): \(error.message)") }
}

class BitsoTests: XCTestCase {
    //TODO: ⚠️ Remove integration test
    
    let bitso = BitsoAPI(session: URLSession.shared)
    
    func testPublicAPIs() {
        let orderBookExpectation = expectation(description: "orderBookExpectation")
        let bookInfoExpectation = expectation(description: "bookInfoExpectation")
        let tradeExpectation = expectation(description: "tradeExpectation")
    
        let getAvailableBooksTask = bitso.getAvailableBooksTask(success: { (books) in
            guard let book = books.payload.first else { return }
            let orderBookTask = self.bitso.orderBookTask(with: book,
                                                         aggregate: true,
                                                         success: { (orderbook) in
                orderBookExpectation.fulfill()
            },
                                                         failure: { error in
                print(error)
            })
            let bookInfoTask = self.bitso.bookInfoTask(with: book,
                                                       success: { (ticker) in
                bookInfoExpectation.fulfill()
            },
                                                       failure: { error in
                print(error)
            })
            let tradeTask = self.bitso.tradesTask(with: book,
                                                  ascending: true,
                                                  limit: 10,
                                                  success: { (trades) in
                tradeExpectation.fulfill()
            },
                                                  failure: { error in
                print(error)
            })
            tradeTask.resume()
            orderBookTask.resume()
            bookInfoTask.resume()
            
        }, failure: { error in
            print(error)
        })
        getAvailableBooksTask.resume()
        wait(for: [orderBookExpectation, bookInfoExpectation, tradeExpectation], timeout: 30.0)
    }

    func testWebSockets() {
        let webSocketExpectation = expectation(description: "webSocketExpectation")
        let getAvailableBooksTask = bitso.getAvailableBooksTask(success:{ (books) in
            guard let book = books.payload.first else { return }
            self.bitso.webSocket(with: book)
        }, failure: { error in  })
        getAvailableBooksTask.resume()
        wait(for: [webSocketExpectation], timeout: 3600.0)
    }
}
