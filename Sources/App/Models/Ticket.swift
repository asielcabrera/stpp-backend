//
//  Ticket.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/13/23.
//

import Fluent
import Vapor

final class Ticket: Model, Content {
    static let schema = "ticket"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
