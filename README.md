![](Assets/banner.png?raw=true)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

### How to use

Think of the Bitso framework like a set of expensive functions that allow you to get `Orders`, `Books`, `Ticker`, and `Trades`.

```
let bitso = BitsoAPI(session: URLSession.shared)
let orderBookExpectation = expectation(description: "orderBookExpectation")
let bookInfoExpectation = expectation(description: "bookInfoExpectation")
let tradeExpectation = expectation(description: "tradeExpectation")

let getAvailableBooksTask = bitso.getAvailableBooksTask { (books, error) in
    guard let books = books else { return }
    guard let book = books.payload.first else { return }
    let orderBookTask = bitso.orderBookTask(with: book, aggregate: true, completion: { (orderbook, error) in
        XCTAssert(orderbook != nil || error != nil, "OrderBook or error should be retrieved")
        orderBookExpectation.fulfill()
    })
    let bookInfoTask = bitso.bookInfoTask(with: book, completion: { (ticker, error) in
        XCTAssert(ticker != nil || error != nil, "Ticker or error should be retrieved")
        bookInfoExpectation.fulfill()
    })
    let tradeTask = bitso.tradesTask(with: book, ascending: true, limit: 10, completion: { (trades, error) in
        XCTAssert(trades != nil || error != nil, "Ticker or error should be retrieved")
        tradeExpectation.fulfill()
    })
    tradeTask.resume()
    orderBookTask.resume()
    bookInfoTask.resume()
}
getAvailableBooksTask.resume()
wait(for: [orderBookExpectation, bookInfoExpectation, tradeExpectation], timeout: 30.0)
```

### How to contribute

**Tasks**

Here are some tasks:

- [x] Public API
- [ ] Private API
- [ ] WebSockets
- [ ] Transfer
- [ ] Account creation

**API Response Models**

To build the models I usually use: http://www.json4swift.com with the latest Swift 4 Codeable Mapping along with this process:

1. Go to **https://bitso.com/api_info**
2. Choose a private endpoint. You can raise an issue and assign it to yourself to communicate that you are working on an specific endpoint
3. Copy the JSON Response
4. Use JSON Response as input of http://www.json4swift.com
5. Download the generated files
6. Remove optionals from the generated files using the next two points
7. You can use Find and Replace to remove the `?` from those files before adding them to the project.
8. You can use Find and Replace to replace the `decodeIfPresent` for a `decode` in the generated files before adding them to the project.
9. Correct automated code in subcontainers by replacing code like `payload = Payload(decoder)` for `decode(Payload.self, key: "payload")`
10. Add the generated files to the project.
11. Test the models using a unit test.
12. Rename structs to verbose names like `Book` instead of `Payload` and `BooksResponse` instead of `Json4Swift_Base`
13. Add your name to the contributors list
14. Raise a Pull Request

**Contributors**

Julio César Guzmán Villanueva
