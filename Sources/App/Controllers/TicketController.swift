//
//  TicketController.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/13/23.
//

import Fluent
import Vapor

struct TicketController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("ticket")
        todos.get(use: index)
        todos.post(use: create)
        todos.group(":ticketID") { todo in
            todo.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [Todo] {
        try await Todo.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Todo {
        let todo = try req.content.decode(Todo.self)
        try await todo.save(on: req.db)
        return todo
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let todo = try await Todo.find(req.parameters.get("ticketID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await todo.delete(on: req.db)
        return .noContent
    }
}