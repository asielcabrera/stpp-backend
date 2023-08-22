//
//  RealRandomGenerator.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Vapor

extension Application.RandomGenerators.Provider {
    static var random: Self {
        .init {
            $0.randomGenerators.use { _ in RealRandomGenerator() }
        }
    }
}

struct RealRandomGenerator: RandomGenerator {
    func generate(bits: Int) -> String {
        [UInt8].random(count: bits / 8).hex
    }
}
