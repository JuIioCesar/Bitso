//
//  Authorization.swift
//  Bitso
//
//  Created by Julio Villanueva on 5/9/18.
//  Copyright © 2018 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

struct Authorization {
    let HTTPMethod: String
    let requestPath: String
    let jsonPayload: String
    let signer: Signer
    
    var header: String {
        let nonce = Int64(Date().timeIntervalSince1970 * 100000)
        let nonceString = "\(nonce)"
        let message = nonceString + HTTPMethod + requestPath + jsonPayload
        let signature = signer.sign(message)
        let auth_header = "Bitso \(signer.publicKey):\(nonceString):\(signature)"
        return auth_header
    }
}
