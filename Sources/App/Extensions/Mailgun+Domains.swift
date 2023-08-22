//
//  MailgunDomain.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Mailgun
import Vapor

extension MailgunDomain {
    static var sandbox: MailgunDomain { .init(Environment.get("MAILGUN_DOMAIN") ?? "", .us)}
}
