/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
public struct Ticker : Codable {
	let book : String
	let volume : String
	let high : String
	let lastTradedPrice : String
	let low : String
	let volumeWeightedAveragePrice : String
	let lowestSellOrder : String
	let highestBuyOrder : String
	let creationTimestamp : String

	enum CodingKeys: String, CodingKey {

		case book = "book"
		case volume = "volume"
		case high = "high"
		case lastTradedPrice = "last"
		case low = "low"
		case volumeWeightedAveragePrice = "vwap"
		case lowestSellOrder = "ask"
		case highestBuyOrder = "bid"
		case creationTimestamp = "created_at"
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		book = try values.decode(String.self, forKey: .book)
		volume = try values.decode(String.self, forKey: .volume)
		high = try values.decode(String.self, forKey: .high)
		lastTradedPrice = try values.decode(String.self, forKey: .lastTradedPrice)
		low = try values.decode(String.self, forKey: .low)
		volumeWeightedAveragePrice = try values.decode(String.self, forKey: .volumeWeightedAveragePrice)
		lowestSellOrder = try values.decode(String.self, forKey: .lowestSellOrder)
		highestBuyOrder = try values.decode(String.self, forKey: .highestBuyOrder)
		creationTimestamp = try values.decode(String.self, forKey: .creationTimestamp)
	}

}
