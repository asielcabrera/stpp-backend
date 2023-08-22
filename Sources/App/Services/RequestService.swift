//
//  RequestService.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Vapor

protocol RequestService {
    func `for`(_ req: Request) -> Self
}
