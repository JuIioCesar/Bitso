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
        let task1 = URLSession.shared.booksTask { (books) in
            let task2 = URLSession.shared.tradesTask(with: books!.payload.first!, completion: { (trades) in
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
            task2.resume()
        }
        task1.resume()
        
        wait(for: [integrationTest], timeout: 30.0)
    }

    
}
