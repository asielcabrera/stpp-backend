//import NIOSSL
//import Fluent
//import FluentPostgresDriver
//import Vapor
//import JWT
//
//// configures your application
//public func configure(_ app: Application) async throws {
//    // uncomment to serve files from /Public folder
//    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
//
//    app.databases.use(.postgres(configuration: SQLPostgresConfiguration(
//        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
//        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
//        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
//        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
//        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
//        tls: .prefer(try .init(configuration: .clientDefault)))
//    ), as: .psql)
//
//    app.jwt.signers.use(.hs256(key: "secret"))
//
//    app.migrations.add(CreateTodo())
//
//
//    // register routes
//    try routes(app)
//}

import Fluent
import FluentPostgresDriver
import Vapor
import JWT
import Mailgun
import QueuesRedisDriver

public func configure(_ app: Application) async throws {
    // MARK: JWT
    if app.environment != .testing {
//        let jwksFilePath = app.directory.workingDirectory + (Environment.get("JWKS_KEYPAIR_FILE") ?? "keypair.jwks")
//        guard
//            let jwks = FileManager.default.contents(atPath: jwksFilePath),
//            let jwksString = String(data: jwks, encoding: .utf8)
//        else {
//            fatalError("Failed to load JWKS Keypair file at: \(jwksFilePath)")
//        }
        app.jwt.signers.use(.hs256(key: "secret"))
    }
    
    // MARK: Database
    // Configure PostgreSQL database
    app.databases.use(.postgres(configuration: SQLPostgresConfiguration(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
    
    // MARK: Middleware
    app.middleware = .init()
    app.middleware.use(ErrorMiddleware.custom(environment: app.environment))
    
    // MARK: Model Middleware
    
    // MARK: Mailgun
    app.mailgun.configuration = .init(apiKey: Environment.get("MAILGUN_APIKEY") ?? "")
//    app.mailgun.configuration = .environment
    app.mailgun.defaultDomain = .sandbox
    
    
    // MARK: App Config
    app.config = .environment
    
    try routes(app)
    try migrations(app)
    try queues(app)
    try services(app)
    
    if app.environment == .development {
        try await app.autoMigrate()
        try app.queues.startInProcessJobs(on: .default)
    }
}
