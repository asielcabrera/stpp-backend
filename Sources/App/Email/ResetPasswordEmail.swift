//
//  ResetPasswordEmail.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Vapor

struct ResetPasswordEmail: Email {
    var templateName: String
    var templateData: [String : String] {
        ["reset_url": resetURL]
    }
    var subject: String {
        "Reset your password"
    }
    
    let resetURL: String
    
    init(resetURL: String) {
        self.resetURL = resetURL
        self.templateName = "reset_password"
    }
}
