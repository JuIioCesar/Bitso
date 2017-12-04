/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Trade : Codable {
	let book : String
	let created_at : String
	let amount : String
	let maker_side : String
	let price : String
	let tid : Int

	enum CodingKeys: String, CodingKey {

		case book = "book"
		case created_at = "created_at"
		case amount = "amount"
		case maker_side = "maker_side"
		case price = "price"
		case tid = "tid"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		book = try values.decode(String.self, forKey: .book)
		created_at = try values.decode(String.self, forKey: .created_at)
		amount = try values.decode(String.self, forKey: .amount)
		maker_side = try values.decode(String.self, forKey: .maker_side)
		price = try values.decode(String.self, forKey: .price)
		tid = try values.decode(Int.self, forKey: .tid)
	}

}
