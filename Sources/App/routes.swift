//import Fluent
//import Vapor
//
//func routes(_ app: Application) throws {
//    app.get { req async in
//        "It works!"
//    }
//
//    app.get("hello") { req async -> String in
//        "Hello, world!"
//    }
//    
//    app.get("me") { req -> HTTPStatus in
//        let payload = try req.jwt.verify(as: TestPayload.self)
//        print(payload)
//        return .ok
//    }
//    
//    // Generate and return a new JWT.
//    app.post("login") { req -> [String: String] in
//        // Create a new instance of our JWTPayload
//        let payload = TestPayload(
//            subject: "vapor",
//            expiration: .init(value: .distantFuture),
//            isAdmin: true
//        )
//        // Return the signed JWT
//        return try [
//            "token": req.jwt.sign(payload)
//        ]
//    }
//
//    try app.register(collection: TodoController())
//}

import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.group("api") { api in
        // Authentication
        try! api.register(collection: AuthenticationController())
    }
}
