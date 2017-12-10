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
    func testPublicAPIs() {
        
        let bitso = BitsoAPI(session: URLSession.shared)
        let orderBookExpectation = expectation(description: "orderBookExpectation")
        let bookInfoExpectation = expectation(description: "bookInfoExpectation")
        let tradeExpectation = expectation(description: "tradeExpectation")
        
        let getAvailableBooksTask = bitso.getAvailableBooksTask { (books, error) in
            guard let books = books else { return }
            guard let book = books.payload.first else { return }
            let orderBookTask = bitso.orderBookTask(with: book, aggregate: true, completion: { (orderbook, error) in
                XCTAssert(orderbook != nil, "OrderBook should be retrieved")
                orderBookExpectation.fulfill()

            })
            let bookInfoTask = bitso.bookInfoTask(with: book, completion: { (ticker, error) in
                XCTAssert(ticker != nil, "Ticker should be retrieved")
                bookInfoExpectation.fulfill()
            })
            let tradeTask = bitso.tradesTask(with: book, ascending: true, limit: 10, completion: { (trades, error) in
                XCTAssert(trades != nil, "Trades should be retrieved")
                tradeExpectation.fulfill()
            })
            tradeTask.resume()
            orderBookTask.resume()
            bookInfoTask.resume()
        }
        getAvailableBooksTask.resume()
        wait(for: [orderBookExpectation, bookInfoExpectation, tradeExpectation], timeout: 30.0)
    }

    
}
