//
//  CreateRefreshToken.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Fluent

struct CreateRefreshToken: AsyncMigration {
    func prepare(on database: Database) async throws -> Void {
        try await database.schema("user_refresh_tokens")
            .id()
            .field("token", .string)
            .field("user_id", .uuid, .references("users", "id", onDelete: .cascade))
            .field("expires_at", .datetime)
            .field("issued_at", .datetime)
            .unique(on: "token")
            .unique(on: "user_id")
            .create()
    }
    
    func revert(on database: Database) async throws -> Void {
        try await database.schema("user_refresh_tokens").delete()
    }
}
