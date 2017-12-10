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
    
    //TODO: Private API interaction
    //TODO: Error codes
    //TODO: Remove integration test
    func testIntegration() {
        let integrationTest = expectation(description: "fulfill integration test")
        let bitso = BitsoAPI(session: URLSession.shared)
        let getAvailableBooksTask = bitso.getAvailableBooksTask { (books, error) in
            guard let books = books else { return }
            guard let book = books.payload.first else { return }
            let orderBookTask = bitso.orderBookTask(with: book, aggregate: true, completion: { (orderbook, error) in
                XCTAssert(orderbook != nil || error != nil, "OrderBook or error should be retrieved")
//                integrationTest.fulfill()
            })
            let bookInfoTask = bitso.bookInfoTask(with: book, completion: { (ticker, error) in
                XCTAssert(ticker != nil || error != nil, "Ticker or error should be retrieved")
//                integrationTest.fulfill()
            })
            let tradeTask = bitso.tradesTask(with: book, ascending: true, limit: 10, completion: { (trades, error) in
                XCTAssert(trades != nil || error != nil, "Ticker or error should be retrieved")
                integrationTest.fulfill()
            })
            tradeTask.resume()
            orderBookTask.resume()
            bookInfoTask.resume()
        }
        getAvailableBooksTask.resume()
        
        wait(for: [integrationTest], timeout: 30.0)
    }

    
}
