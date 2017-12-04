//
//  BitsoTests.swift
//  BitsoTests
//
//  Created by Julio Cesar Guzman Villanueva on 12/3/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import XCTest
@testable import Bitso

class BitsoTests: XCTestCase {
    
    //TODO: Private API interaction
    //TODO: Error codes
    //TODO: Remove integration test
    func testIntegration() {
        let integrationTest = expectation(description: "fulfill integration test")
        let booksTask = URLSession.shared.booksTask { (books) in
            let tradesTask = URLSession.shared.tradesTask(with: books!.payload.first!, ascending: true, completion: { (trades) in
                trades?.payload.forEach({ (trade) in
                    print("""
                        Book: \(trade.book)
                        Trade: \(trade.tid)
                        Amount: \(trade.amount)
                        Price: \(trade.price)
                        Created at: \(trade.created_at)
                        """)
                })
                integrationTest.fulfill()
            })
            tradesTask.resume()
        }
        booksTask.resume()
        
        wait(for: [integrationTest], timeout: 30.0)
    }

    
}
