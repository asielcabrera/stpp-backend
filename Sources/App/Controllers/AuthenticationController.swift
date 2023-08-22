//
//  AuthenticationController.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Vapor
import Fluent

struct AuthenticationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("auth") { auth in
            auth.post("register", use: register)
            auth.post("login", use: login)
            
            auth.group("email-verification") { emailVerificationRoutes in
                emailVerificationRoutes.get("", use: verifyEmail)
                emailVerificationRoutes.post("", use: sendEmailVerification)
                
            }
            
            auth.group("reset-password") { resetPasswordRoutes in
                resetPasswordRoutes.post("", use: resetPassword)
                resetPasswordRoutes.get("verify", use: verifyResetPasswordToken)
            }
            auth.post("recover", use: recoverAccount)
            
            auth.post("accessToken", use: refreshAccessToken)
            
            // Authentication required
            auth.group(UserAuthenticator()) { authenticated in
                authenticated.get("me", use: getCurrentUser)
            }
        }
    }
    
    private func register(_ req: Request) async throws -> HTTPStatus {
        try RegisterRequest.validate(content: req)
        let registerRequest = try req.content.decode(RegisterRequest.self)
        guard registerRequest.password == registerRequest.confirmPassword else {
            throw AuthenticationError.passwordsDontMatch
        }
        
        let passHash = try req.password.hash(registerRequest.password)
        let user = try User(from: registerRequest, hash: passHash)
        
        
        do {
            try await req.users.create(user)
            
            try await req.emailVerifier.verify(for: user)
            return .created
        } catch let error as DatabaseError where error.isConstraintFailure {
            throw AuthenticationError.emailAlreadyExists
        } catch {
            throw error
        }
    }
    
    private func login(_ req: Request) async throws -> LoginResponse {
        try LoginRequest.validate(content: req)
        let loginRequest = try req.content.decode(LoginRequest.self)
        
        guard let user = try await req.users.find(email: loginRequest.email) else { throw AuthenticationError.invalidEmailOrPassword }
        guard user.isEmailVerified else { throw AuthenticationError.emailIsNotVerified }
        
        let passwordMatches = try await req.password.async.verify(loginRequest.password, created: user.passwordHash)
        guard passwordMatches else { throw AuthenticationError.invalidEmailOrPassword }
        
        try await req.refreshTokens.delete(for: user.requireID())
        
        let token = req.random.generate(bits: 256)
        let refreshToken = try RefreshToken(token: SHA256.hash(token), userID: user.requireID())
        
        try await req.refreshTokens.create(refreshToken)
        
        let accessToken = try req.jwt.sign(Payload(with: user))
        
        return LoginResponse(user: UserDTO(from: user), accessToken: accessToken, refreshToken: token)
        
    }
    
    private func refreshAccessToken(_ req: Request) async throws -> AccessTokenResponse {
        let accessTokenRequest = try req.content.decode(AccessTokenRequest.self)
        let hashedRefreshToken = SHA256.hash(accessTokenRequest.refreshToken)
        
        guard let refreshToken = try await req.refreshTokens.find(token: hashedRefreshToken) else { throw AuthenticationError.refreshTokenOrUserNotFound }
        
        guard refreshToken.expiresAt > Date() else { throw AuthenticationError.refreshTokenHasExpired }
        
        guard let user = try await req.users.find(id: refreshToken.user.requireID()) else {
            throw AuthenticationError.refreshTokenOrUserNotFound
        }
        
        
        let token = req.random.generate(bits: 256)
        let hashedToken = SHA256.hash(token)
        
        let newRefreshToken = try RefreshToken(token: hashedToken, userID: user.requireID())
        let payload = try Payload(with: user)
        let accessToken = try req.jwt.sign(payload)
        
        try await req.refreshTokens.create(newRefreshToken)
        
        return AccessTokenResponse(refreshToken: token, accessToken: accessToken)
        
    }
    
    private func getCurrentUser(_ req: Request) async throws -> UserDTO {
        let payload = try req.auth.require(Payload.self)
        
        guard let user = try await req.users.find(id: payload.userID) else {
            throw AuthenticationError.userNotFound
        }
        return UserDTO(from: user)
    }
    
    private func verifyEmail(_ req: Request) async throws -> HTTPStatus {
        let token = try req.query.get(String.self, at: "token")
        print(token)
        let hashedToken = SHA256.hash(token)
        print(hashedToken)
        guard let emailToken = try await req.emailTokens.find(token: hashedToken) else { throw AuthenticationError.emailTokenNotFound }
        
        guard emailToken.expiresAt > .now else { throw AuthenticationError.emailTokenHasExpired }
        
        try await req.emailTokens.delete(emailToken)
        try await req.users.set(\.$isEmailVerified, to: true, for: emailToken.$user.id)
        
        return .ok
    }
    
    private func resetPassword(_ req: Request) async throws -> HTTPStatus {
        let resetPasswordRequest = try req.content.decode(ResetPasswordRequest.self)
        
        guard let user = try await req.users.find(email: resetPasswordRequest.email) else {
            return .noContent
        }
        
        try await req.passwordResetter.reset(for: user)
        
        return .ok
    }
    
    private func verifyResetPasswordToken(_ req: Request) async throws -> HTTPStatus {
        let token = try req.query.get(String.self, at: "token")
        let hashedToken = SHA256.hash(token)
        
        guard let passwordToken = try await req.passwordTokens.find(token: hashedToken) else { throw AuthenticationError.invalidPasswordToken }
        
        guard passwordToken.expiresAt > .now else {
            try await req.passwordTokens.delete(passwordToken)
            throw AuthenticationError.passwordTokenHasExpired
        }
        
        return .noContent
    }
    
    private func recoverAccount(_ req: Request) async throws -> HTTPStatus {
        try RecoverAccountRequest.validate(content: req)
        let content = try req.content.decode(RecoverAccountRequest.self)
        
        guard content.password == content.confirmPassword else {
            throw AuthenticationError.passwordsDontMatch
        }
        
        let hashedToken = SHA256.hash(content.token)
        
        guard let passwordToken = try await req.passwordTokens.find(token: hashedToken) else {
            throw AuthenticationError.invalidPasswordToken
        }
        
        guard passwordToken.expiresAt > .now else {
            try await req.passwordTokens.delete(passwordToken)
            throw AuthenticationError.passwordTokenHasExpired
        }
        
        let digest = try await req.password.async.hash(content.password)
        try await req.users.set(\.$passwordHash, to: digest, for: passwordToken.$user.id)
        try await req.passwordTokens.delete(for: passwordToken.$user.id)
        
        return .noContent
        
    }
    
    private func sendEmailVerification(_ req: Request) async throws -> HTTPStatus {
        let content = try req.content.decode(SendEmailVerificationRequest.self)

        guard let user = try await req.users.find(email: content.email) else { throw AuthenticationError.userNotFound }
        
        if user.isEmailVerified {
            return .notFound
        }
        
        try await req.emailVerifier.verify(for: user)
        return .noContent
    }
}
