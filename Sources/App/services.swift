//
//  services.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Vapor

func services(_ app: Application) throws {
    app.randomGenerators.use(.random)
    app.repositories.use(.database)
}
