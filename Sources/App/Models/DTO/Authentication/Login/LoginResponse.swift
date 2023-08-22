//
//  LoginResponse.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Vapor

struct LoginResponse: Content {
    let user: UserDTO
    let accessToken: String
    let refreshToken: String
}
