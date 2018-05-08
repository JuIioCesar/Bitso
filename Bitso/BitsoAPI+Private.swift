//
//  BitsoAPI+Private.swift
//  Bitso
//
//  Created by Julio Villanueva on 5/7/18.
//  Copyright © 2018 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

extension BitsoAPI {
    public func getFeesTask(success: @escaping (FeesResponse) -> Void,
                            failure: @escaping (BitsoError?) -> Void ) -> URLSessionTask {
        let endpoint = FeesEndpoint()
        return session.decodeJSONTask(from: endpoint,
                                      success: success,
                                      failure: failure)
    }
}
