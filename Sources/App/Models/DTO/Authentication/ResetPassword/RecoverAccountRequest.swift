//
//  RecoverAccountRequest.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Vapor

struct RecoverAccountRequest: Content {
    let password: String
    let confirmPassword: String
    let token: String
}

extension RecoverAccountRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("password", as: String.self, is: .count(8...))
        validations.add("confirmPassword", as: String.self, is: !.empty)
        validations.add("token", as: String.self, is: !.empty)
    }
}
