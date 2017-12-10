![](Assets/banner.png?raw=true)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

### How to use

The Bitso framework allows you to create URLSessionTasks that return bitso API models such as `Orders`, `Books`, `Ticker`, and `Trades`.

```
let getAvailableBooksTask = URLSession.shared.getAvailableBooksTask { (books) in
    let tradesTask = URLSession.shared.tradesTask(with: books!.payload.first!, completion: { (trades) in
        trades?.payload.forEach({ (trade) in
        print("""
            Book: \(trade.book)
            Trade: \(trade.tid)
            Amount: \(trade.amount)
            Price: \(trade.price)
            Created at: \(trade.created_at)
            """)
            })
        })
    tradesTask.resume()
}
getAvailableBooksTask.resume()
```

### How to contribute

**API Response Models**

The workflow for adding endpoints it's mostly automated and it's the next one:

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

**Refactoring**

The `Public Rest API.swift` file is a mess. I could use some cleaning.

To build the models I usually use: http://www.json4swift.com with the latest Swift 4 Codeable Mapping

**Contributors**

Julio César Guzmán Villanueva
