//
//  ResetPasswordRequest.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Vapor

struct ResetPasswordRequest: Content {
    let email: String
}

extension ResetPasswordRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
    }
}
