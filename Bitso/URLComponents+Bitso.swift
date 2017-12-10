//
//  URLComponents+Bitso.swift
//  Bitso
//
//  Created by Julio Cesar Guzman Villanueva on 12/10/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

extension URLComponents {
    
    enum Scheme: String {
        case secure = "https"
    }
    
    static var bitso: URLComponents {
        var components = URLComponents()
        components.scheme = URLComponents.Scheme.secure.rawValue
        components.host = "api-dev.bitso.com"
        return components
    }
}
