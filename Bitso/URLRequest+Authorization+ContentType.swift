//
//  URLRequest.swift
//  Bitso
//
//  Created by Julio Villanueva on 5/9/18.
//  Copyright © 2018 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

extension URLRequest {
    static func make(url: URL, authorization: Authorization?, contentType: ContentType?) -> URLRequest {
        var request = URLRequest(url: url)
        if let authorization = authorization {
            request.addValue(authorization.header, forHTTPHeaderField: HTTPHeaderField.Authorization.rawValue)
        }
        if let contentType = contentType {
            request.setValue(contentType.rawValue, forHTTPHeaderField: HTTPHeaderField.ContentType.rawValue)
        }
        return request
    }
}
