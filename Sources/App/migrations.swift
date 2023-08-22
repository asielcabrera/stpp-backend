//
//  migrations.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Vapor

func migrations(_ app: Application) throws {
    // Initial Migrations
    app.migrations.add(CreateUser())
    app.migrations.add(CreateRefreshToken())
    app.migrations.add(CreateEmailToken())
    app.migrations.add(CreatePasswordToken())
}
