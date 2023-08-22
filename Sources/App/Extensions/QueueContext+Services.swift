//
//  QueueContext+Services.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Fluent
import Queues
import QueuesRedisDriver
import Mailgun

extension QueueContext {
    var db: Database {
        application.databases
            .database(logger: self.logger, on: self.eventLoop)!
    }
    
    func mailgun() -> MailgunProvider {
        application.mailgun().delegating(to: self.eventLoop)
    }
    
    func mailgun(_ domain: MailgunDomain? = nil) -> MailgunProvider {
        application.mailgun(domain).delegating(to: self.eventLoop)
    }
    
    var appConfig: AppConfig {
        application.config
    }
}
