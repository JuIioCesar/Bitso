//
//  URLSession+JSONDecodable.swift
//  Bitso
//
//  Created by Julio Cesar Guzman Villanueva on 12/10/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

extension URLSession {
    func decodeJSONTask<T: Decodable>(from endpoint: Endpoint,
                                      authorization: Authorization? = nil,
                                      contentType: ContentType? = nil,
                                      success: @escaping (T) -> Void,
                                      failure: @escaping (BitsoError?) -> Void) -> URLSessionTask {
        var components = URLComponents.bitso
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        assert(components.url != nil, "URL components couldn't be formed. Please check your URLComponents.")
        let request = URLRequest.make(url: components.url!, authorization: authorization, contentType: contentType)
        let task = dataTask(with: request) { (data, _, _) in
            guard let data = data else {
                failure(nil)
                return
            }
            let result = try? JSONDecoder().decode(T.self, from: data)
            let error = try? JSONDecoder().decode(BitsoErrorResponse.self, from: data)
            if let result = result {
                success(result)
                return
            }
            if let error = error {
                failure(error.error)
                return
            }
            failure(nil)
        }
        return task
    }
}
