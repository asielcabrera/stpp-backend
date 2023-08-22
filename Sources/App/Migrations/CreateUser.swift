//
//  CreateUser.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws -> Void {
        try await database.schema("users")
            .id()
            .field("full_name", .string, .required)
            .field("email", .string, .required)
            .field("password_hash", .string, .required)
            .field("is_admin", .bool, .required, .custom("DEFAULT FALSE"))
            .field("is_email_verified", .bool, .required, .custom("DEFAULT FALSE"))
            .unique(on: "email")
            .create()
    }
    
    func revert(on database: Database) async throws -> Void {
        try await database.schema("users").delete()
    }
}
