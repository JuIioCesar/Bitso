//
//  FeesEnpoint.swift
//  Bitso
//
//  Created by Julio Villanueva on 5/7/18.
//  Copyright © 2018 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

struct FeesEndpoint: Endpoint {
    let path = "/v3/fees"
    var queryItems = [URLQueryItem]()
}
