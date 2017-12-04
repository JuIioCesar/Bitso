/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Book : Codable {
	let book : String
	let minimum_amount : String
	let maximum_amount : String
	let minimum_price : String
	let maximum_price : String
	let minimum_value : String
	let maximum_value : String

	enum CodingKeys: String, CodingKey {

		case book = "book"
		case minimum_amount = "minimum_amount"
		case maximum_amount = "maximum_amount"
		case minimum_price = "minimum_price"
		case maximum_price = "maximum_price"
		case minimum_value = "minimum_value"
		case maximum_value = "maximum_value"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		book = try values.decode(String.self, forKey: .book)
		minimum_amount = try values.decode(String.self, forKey: .minimum_amount)
		maximum_amount = try values.decode(String.self, forKey: .maximum_amount)
		minimum_price = try values.decode(String.self, forKey: .minimum_price)
		maximum_price = try values.decode(String.self, forKey: .maximum_price)
		minimum_value = try values.decode(String.self, forKey: .minimum_value)
		maximum_value = try values.decode(String.self, forKey: .maximum_value)
	}

}
