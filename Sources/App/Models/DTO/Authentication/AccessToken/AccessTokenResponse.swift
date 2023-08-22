//
//  AccessTokenResponse.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Vapor

struct AccessTokenResponse: Content {
    let refreshToken: String
    let accessToken: String
}
