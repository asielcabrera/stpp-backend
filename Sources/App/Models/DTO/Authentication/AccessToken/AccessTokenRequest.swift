//
//  AccessTokenRequest.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Vapor

struct AccessTokenRequest: Content {
    let refreshToken: String
}
