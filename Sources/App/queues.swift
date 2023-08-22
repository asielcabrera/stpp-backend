//
//  File.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Vapor
import Queues
import QueuesRedisDriver

func queues(_ app: Application) throws {
    // MARK: Queues Configuration
    
    try app.queues.use(.redis(url: "redis://redis:6379"))
    
    // MARK: Jobs
    app.queues.add(EmailJob())
}
