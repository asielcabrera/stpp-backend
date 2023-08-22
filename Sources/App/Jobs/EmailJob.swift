//
//  EmailJob.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Vapor
import Queues
import QueuesRedisDriver
import Mailgun

struct EmailPayload: Codable {
    let email: AnyEmail
    let recipient: String
    
    init<E: Email>(_ email: E, to recipient: String) {
        self.email = AnyEmail(email)
        self.recipient = recipient
    }
}

struct EmailJob: AsyncJob {
    typealias Payload = EmailPayload
    
    func dequeue(_ context: QueueContext, _ payload: EmailPayload) async throws {
        
        let mailgunMessage = MailgunTemplateMessage(
            from: context.appConfig.noReplyEmail,
            to: payload.recipient,
            subject: payload.email.subject,
            template: payload.email.templateName,
            templateData: payload.email.templateData
        )
        print(payload.email.templateData)
        let _ = context.mailgun().send(mailgunMessage)
    }
    
    func error(_ context: QueueContext, _ error: Error, _ payload: EmailPayload) async throws {
        print("error: \(error)")
    }
}
