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
        wait(for: [orderBookExpectation, bookInfoExpectation, tradeExpectation], timeout: 300.0)
    }

    func testWebSockets() {
        let webSocketExpectation = expectation(description: "webSocketExpectation")
        let getAvailableBooksTask = bitso.getAvailableBooksTask(success:{ (books) in
            guard let book = books.payload.first else { return }
//            self.bitso.tradesStream(with: book, success: { (response) in
//                response.payload.forEach({ (message) in
//                    print(message.rate)
//                })
//            }, failure: { (error) in
//                print(error)
//            }, close: { (code, cause, clean) in
//
//            })
            self.bitso.ordersStream(with: book, success: { (response) in
                response.payload.asks.forEach({ (ask) in
                    print("Venta: \(ask.rate) \(ask.amount) \(book.book)")
                })
                response.payload.bids.forEach({ (bid) in
                    print("Compra: \(bid.rate) \(bid.amount) \(book.book)")
                })
            }, failure: { (error) in

            }, close: { (code, message, clean) in

            })
//            self.bitso.diffOrdersStream(with: book, success: { (response) in
//                response.payload.forEach({ (message) in
//                    print(message.)
//                })
//            }, failure: { (error) in
//
//            }, close: { (code, message, clean) in
//
//            })
        }, failure: { error in  })
        getAvailableBooksTask.resume()
        wait(for: [webSocketExpectation], timeout: 3600.0)
    }
}
