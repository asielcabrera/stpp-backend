//
//  Request+RandomGenerator.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Vapor

extension Request {
    var random: RandomGenerator {
        self.application.random
    }
}
