//
//  Signer.swift
//  Bitso
//
//  Created by Julio Villanueva on 5/9/18.
//  Copyright © 2018 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

protocol Signer {
    var secretKey: String { get }
    var publicKey: String { get }
    func sign(_ string: String) -> String
}
