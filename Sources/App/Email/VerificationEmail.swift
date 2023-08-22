//
//  VerificationEmail.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Vapor

struct VerificationEmail: Email {
    var templateName: String
    let verifyUrl: String
    
    var subject: String {
        "Please verify your email"
    }
    
    var templateData: [String : String]
    
    init(verifyUrl: String) {
        self.verifyUrl = verifyUrl
        self.templateName = "email_verification"
        self.templateData = ["verify_url": verifyUrl]
    }
    
    
    mutating func append(key: String, value: String) {
        self.templateData.updateValue(value, forKey: key)
    }
}
