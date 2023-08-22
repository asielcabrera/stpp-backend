//
//  Email.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

protocol Email: Codable {
    var templateName: String { get }
    var templateData: [String: String] { get }
    var subject: String { get }
}

struct AnyEmail: Email {
    var templateName: String
    var templateData: [String : String]
    var subject: String
    
    init<E>(_ email: E) where E: Email {
        self.templateData = email.templateData
        self.templateName = email.templateName
        self.subject = email.subject
    }
}
